import React, { useState, useRef } from "react";
import {
  Image,
  Text,
  View,
  StyleSheet,
  TouchableOpacity,
  Animated,
  Easing,
  Platform
} from "react-native";
import { Inventory } from "./store/inventory";


//optimize List with FlatList

interface ProductItemProps {
  inventoryItem: Inventory; //define type of prop
}

const ProductItem: React.FC<ProductItemProps> = ({ inventoryItem }) => {
  const { fields } = inventoryItem;
  const {
    "Product Name": productName,
    "Product Image": productImage,
    "Product Categories": productCategories
  } = fields;


  //------------------Date + Date calculation------------------
  const options: Intl.DateTimeFormatOptions = {
    year: "numeric",
    month: "2-digit",
    day: "2-digit"
  };
  const createdTime = inventoryItem.createdTime;
  // const createdDateOnly = inventoryItem.createdTime.split("T")[0]; one option
  const createdDateStr = new Date(createdTime).toLocaleDateString(
    "de-DE",
    options
  ); // other option
  const createdDate = new Date(createdTime);
  const sevenDaysAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000);
  const timeDiff = Math.ceil(
    (sevenDaysAgo.getTime() - createdDate.getTime()) / (24 * 60 * 60 * 1000)
  );


  //------------------Product Categories------------------

  const productCategoriesArray = productCategories
    ? productCategories
        .replace(/(en:|de:|fr:)/g, "") //remove en: de: fr: from string
        .split(/\s*,\s*|\s*und\s*|\s{1}and\s*|\s{1}en\s{1}|\s{2}/) // split words into singlestrings, make words when comma with/wtihout spaces + "und" "and" "en "double space"
        .filter(
          (word, index, self) =>
            word &&
            word !== "und" &&
            word !== "and" &&
            word !== "," &&
            word !== "" &&
            word !== "en" && //netherlands "and"
            self.findIndex((w) => w.toLowerCase() === word.toLowerCase()) ===
              index //for comparison to lowerCase, keep first word of duplicates
        )
    : [];

  //------------------Toggle Item Animation ------------------
  const [isExpanded, setIsExpanded] = useState(false);
  const animatedHeight = useRef(new Animated.Value(0)).current;

  function toggleExpanded () {
    const tagHeight = 27; //approximate height of each tag
    let expandedHeight =
      productCategoriesArray.length > 0
        ? productCategoriesArray.length * tagHeight
        : 30;
    if (productCategoriesArray.length === 1) {
      //one tag is too small to calculate height, set to 50 instead
      expandedHeight = 50;
    }

    if (isExpanded) {
      Animated.timing(animatedHeight, {
        toValue: 0,
        duration: 300,
        easing: Easing.ease,
        useNativeDriver: false
      }).start();
    } else {
      Animated.timing(animatedHeight, {
        toValue: expandedHeight, //height of card opened
        duration: 300,
        easing: Easing.ease,
        useNativeDriver: false
      }).start();
    }
    setIsExpanded(!isExpanded);
  };

  return (
    <View style={styles.containerMain}>
      <Animated.Image
        source={
          productImage
            ? { uri: productImage }
            : require("../assets/image_placeholder.png")
        }
        style={[
          styles.imageProductCollapsed,
          {
            height: animatedHeight.interpolate({
              //interpolate let card toggle and image toggle be synchron
              inputRange: [0, 170],
              outputRange: [64, 112] //change of productImageHeight in px
            })
          }
        ]}
        resizeMode="contain"
      />

      <View style={styles.flexRightItems}>
        <View style={styles.containerTop}>
          <Text
            style={styles.textTitle}
            numberOfLines={isExpanded ? undefined : 1}
          >
            {productName !== undefined ? productName : "No product name"}
          </Text>
          <View style={styles.containerChevronAndBadge}>
            {timeDiff < 7 ? (
              <View style={styles.containerBadge}>
                <Text style={styles.textBadge}>NEW</Text>
              </View>
            ) : null}
            <TouchableOpacity onPress={toggleExpanded}>
              <Image
                source={
                  isExpanded
                    ? require("../assets/chevron-up.png")
                    : require("../assets/chevron-down.png")
                }
                style={styles.imageChevron}
              />
            </TouchableOpacity>
          </View>
        </View>

        <Text style={styles.textDate}>{createdDateStr}</Text>

        <Animated.View
          style={{ height: animatedHeight, overflow: "hidden", marginTop: 12 }}
        >
          <View style={styles.containerTag}>
            {productCategoriesArray.map((tag, index) => (
              <View key={index}>
                <Text style={styles.textTag}>{tag}</Text>
              </View>
            ))}
          </View>
        </Animated.View>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  containerMain: {
    backgroundColor: "#F8F9FC",
    flexDirection: "row",
    justifyContent: "center",
    alignItems: "flex-start",
    flexWrap: "wrap",
    gap: 12,
    marginTop: 16,
    marginBottom: -4, //margin bottom should be 12, special case for first element (16topMargin-4bottomMargin=12)
    borderRadius: 4,
    marginLeft: 16,
    marginRight: 16,
    padding: 8,
    shadowColor: "#1B2633",
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.25,
    shadowRadius: 3,
    elevation: 5 //shadow for Android
  },

  imageProductCollapsed: {
    width: 85,
    height: 64
  },

  flexRightItems: {
    flexDirection: "column",
    justifyContent: "flex-start",
    flex: 1, //fill remaining space
    flexWrap: "wrap"
  },

  containerTop: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "flex-start",
    flexWrap: "nowrap",
    gap: 12
  },

  containerChevronAndBadge: {
    flexDirection: "row",
    alignItems: "center",
    flexWrap: "nowrap"
  },

  textTitle: {
    fontFamily: "Roboto",
    fontSize: 20,
    fontWeight: "900",
    lineHeight: 22,
    color: "#1B2633",
    flexShrink: 1,
    marginBottom: 12,
  },

  containerBadge: {
    backgroundColor: "#333333",
    width: 53,
    height: 26,
    gap: 10,
    flexShrink: 0,
    flexDirection: "row",
    justifyContent: "center",
    alignItems: "center",
    borderTopLeftRadius: 9,
    borderTopRightRadius: 0,
    borderBottomRightRadius: 9,
    borderBottomLeftRadius: 9
  },

  textBadge: {
    color: "#FFFFFF",
    fontWeight: "bold",
    textAlign: "center"
  },

  imageChevron: {
    width: 34,
    height: 34,
    marginLeft: 12
  },

  textDate: {
    fontFamily: "Roboto",
    fontSize: 12,
    fontWeight: "400",
    lineHeight: 16,
    color: "#1B2633",
  },

  containerTag: {
    // borderRadius: 5,
    flexDirection: "row",
    justifyContent: "flex-start",
    flexWrap: "wrap"
  },

  textTag: {
    backgroundColor: "#D4E5FF",
    fontSize: 12,
    textAlign: "center",
    borderRadius: Platform.OS === "ios" ? 10 : 48,
    paddingTop: 5,
    paddingRight: 14,
    paddingBottom: 5,
    paddingLeft: 14,
    marginVertical: 3,
    marginRight: 5,
    overflow: "hidden" //otherwise corner not round
  }
});

export default ProductItem;
