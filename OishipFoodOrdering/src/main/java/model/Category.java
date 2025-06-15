package model;

public class Category {

    private int catID;
    private String catName;
    private String catDescription;

    public Category() {
    }

    public Category(String catName, String catDescription) {
        this.catName = catName;
        this.catDescription = catDescription;
    }

    public Category(int catID, String catName, String catDescription) {
        this.catID = catID;
        this.catName = catName;
        this.catDescription = catDescription;
    }

    // Getters and setters
    public int getCatID() {
        return catID;
    }

    public void setCatID(int catID) {
        this.catID = catID;
    }

    public String getCatName() {
        return catName;
    }

    public void setCatName(String catName) {
        this.catName = catName;
    }

    public String getCatDescription() {
        return catDescription;
    }

    public void setCatDescription(String catDescription) {
        this.catDescription = catDescription;
    }
}
