//using System;
//using Microsoft.EntityFrameworkCore.Metadata;
//using Microsoft.EntityFrameworkCore.Migrations;

//#nullable disable

//namespace Lakberendezes.Migrations
//{
//    /// <inheritdoc />
//    public partial class ModifyCategoriesTable : Migration
//    {
//        /// <inheritdoc />
//        protected override void Up(MigrationBuilder migrationBuilder)
//        {
//            migrationBuilder.AlterDatabase()
//                .Annotation("MySql:CharSet", "utf8mb4");


//            migrationBuilder.CreateTable(
//                name: "kategories",
//                columns: table => new
//                {
//                    id = table.Column<int>(type: "int", nullable: false)
//                        .Annotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn),
//                    name = table.Column<string>(type: "longtext", nullable: false)
//                        .Annotation("MySql:CharSet", "utf8mb4")
//                },
//                constraints: table =>
//                {
//                    table.PrimaryKey("PK_kategories", x => x.id);
//                })
//            .Annotation("MySql:CharSet", "utf8mb4");

//            migrationBuilder.CreateTable(
//                name: "shops",
//                columns: table => new
//                {
//                    id = table.Column<int>(type: "int", nullable: false)
//                        .Annotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn),
//                    name = table.Column<string>(type: "longtext", nullable: false)
//                        .Annotation("MySql:CharSet", "utf8mb4"),
//                    websiteurl = table.Column<string>(type: "longtext", nullable: false)
//                        .Annotation("MySql:CharSet", "utf8mb4")
//                },
//                constraints: table =>
//                {
//                    table.PrimaryKey("PK_shops", x => x.id);
//                })
//                .Annotation("MySql:CharSet", "utf8mb4");

//            migrationBuilder.CreateTable(
//                name: "users",
//                columns: table => new
//                {
//                    id = table.Column<int>(type: "int", nullable: false)
//                        .Annotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn),
//                    email = table.Column<string>(type: "longtext", nullable: false)
//                        .Annotation("MySql:CharSet", "utf8mb4"),
//                    PASSWORD_hash = table.Column<string>(type: "longtext", nullable: false)
//                        .Annotation("MySql:CharSet", "utf8mb4"),
//                    fullname = table.Column<string>(type: "longtext", nullable: false)
//                        .Annotation("MySql:CharSet", "utf8mb4"),
//                    datet = table.Column<DateTime>(type: "datetime(6)", nullable: false)
//                },
//                constraints: table =>
//                {
//                    table.PrimaryKey("PK_users", x => x.id);
//                })
//                .Annotation("MySql:CharSet", "utf8mb4");

//            migrationBuilder.CreateTable(
//                name: "producttype",
//                columns: table => new
//                {
//                    id = table.Column<int>(type: "int", nullable: false)
//                        .Annotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn),
//                    categoryid = table.Column<int>(type: "int", nullable: false),
//                    name = table.Column<string>(type: "longtext", nullable: false)
//                        .Annotation("MySql:CharSet", "utf8mb4")
//                },
//                constraints: table =>
//                {
//                    table.PrimaryKey("PK_producttype", x => x.id);
//                    table.ForeignKey(
//                        name: "FK_producttype_kategories_categoryid",
//                        column: x => x.categoryid,
//                        principalTable: "kategories",
//                        principalColumn: "id",
//                        onDelete: ReferentialAction.Cascade);
//                })
//                .Annotation("MySql:CharSet", "utf8mb4");

//            migrationBuilder.CreateTable(
//                name: "userplan",
//                columns: table => new
//                {
//                    id = table.Column<int>(type: "int", nullable: false)
//                        .Annotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn),
//                    userid = table.Column<int>(type: "int", nullable: false),
//                    plandata = table.Column<string>(type: "longtext", nullable: false)
//                        .Annotation("MySql:CharSet", "utf8mb4"),
//                    createdat = table.Column<DateTime>(type: "datetime(6)", nullable: false)
//                },
//                constraints: table =>
//                {
//                    table.PrimaryKey("PK_userplan", x => x.id);
//                    table.ForeignKey(
//                        name: "FK_userplan_users_userid",
//                        column: x => x.userid,
//                        principalTable: "users",
//                        principalColumn: "id",
//                        onDelete: ReferentialAction.Cascade);
//                })
//                .Annotation("MySql:CharSet", "utf8mb4");

//            migrationBuilder.CreateTable(
//                name: "products",
//                columns: table => new
//                {
//                    id = table.Column<int>(type: "int", nullable: false)
//                        .Annotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn),
//                    name = table.Column<string>(type: "longtext", nullable: false)
//                        .Annotation("MySql:CharSet", "utf8mb4"),
//                    price = table.Column<decimal>(type: "decimal(65,30)", nullable: false),
//                    shoplink = table.Column<string>(type: "longtext", nullable: false)
//                        .Annotation("MySql:CharSet", "utf8mb4"),
//                    imageurl = table.Column<string>(type: "longtext", nullable: false)
//                        .Annotation("MySql:CharSet", "utf8mb4"),
//                    shopid = table.Column<int>(type: "int", nullable: false),
//                    product_type_id = table.Column<int>(type: "int", nullable: false),
//                    roomid = table.Column<int>(type: "int", nullable: false)
//                },
//            constraints: table =>
//        {
//            table.PrimaryKey("PK_products", x => x.id);
//            table.ForeignKey(
//                name: "FK_products_kategories_roomid",
//                column: x => x.roomid,
//                principalTable: "kategories",
//                principalColumn: "id",
//                onDelete: ReferentialAction.Cascade);
//            table.ForeignKey(
//                name: "FK_products_producttype_product_type_id",
//                column: x => x.product_type_id,
//                principalTable: "producttype",
//                principalColumn: "id",
//                onDelete: ReferentialAction.Cascade);
//            table.ForeignKey(
//                name: "FK_products_shops_shopid",
//                column: x => x.shopid,
//                principalTable: "shops",
//                principalColumn: "id",
//                onDelete: ReferentialAction.Cascade);
//        });
//            .Annotation("MySql:CharSet", "utf8mb4");

//            migrationBuilder.CreateTable(
//                name: "planproducts",
//                columns: table => new
//                {
//                    id = table.Column<int>(type: "int", nullable: false)
//                        .Annotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn),
//                    productid = table.Column<int>(type: "int", nullable: false),
//                    userplanid = table.Column<int>(type: "int", nullable: false),
//                    Userplansid = table.Column<int>(type: "int", nullable: false),
//                    position = table.Column<string>(type: "longtext", nullable: false)
//                        .Annotation("MySql:CharSet", "utf8mb4")
//                },
//                constraints: table =>
//                {
//                    table.PrimaryKey("PK_planproducts", x => x.id);
//                    table.ForeignKey(
//                        name: "FK_planproducts_products_userplanid",
//                        column: x => x.userplanid,
//                        principalTable: "products",
//                        principalColumn: "id",
//                        onDelete: ReferentialAction.Cascade);
//                    table.ForeignKey(
//                        name: "FK_planproducts_userplan_Userplansid",
//                        column: x => x.Userplansid,
//                        principalTable: "userplan",
//                        principalColumn: "id",
//                        onDelete: ReferentialAction.Cascade);
//                })
//                .Annotation("MySql:CharSet", "utf8mb4");

//            migrationBuilder.CreateIndex(
//                name: "IX_planproducts_userplanid",
//                table: "planproducts",
//                column: "userplanid");

//            migrationBuilder.CreateIndex(
//                name: "IX_planproducts_Userplansid",
//                table: "planproducts",
//                column: "Userplansid");

//            migrationBuilder.CreateIndex(
//                name: "IX_products_product_type_id",
//                table: "products",
//                column: "product_type_id");

//            migrationBuilder.CreateIndex(
//                name: "IX_products_roomid",
//                table: "products",
//                column: "roomid");

//            migrationBuilder.CreateIndex(
//                name: "IX_products_shopid",
//                table: "products",
//                column: "shopid");

//            migrationBuilder.CreateIndex(
//                name: "IX_producttype_categoryid",
//                table: "producttype",
//                column: "categoryid");

//            migrationBuilder.CreateIndex(
//                name: "IX_userplan_userid",
//                table: "userplan",
//                column: "userid");
//        }

//        / <inheritdoc />
//        protected override void Down(MigrationBuilder migrationBuilder)
//        {
//            migrationBuilder.DropTable(
//                name: "planproducts");

//            migrationBuilder.DropTable(
//                name: "products");

//            migrationBuilder.DropTable(
//                name: "userplan");

//            migrationBuilder.DropTable(
//                name: "producttype");

//            migrationBuilder.DropTable(
//                name: "shops");

//            migrationBuilder.DropTable(
//                name: "users");

//            migrationBuilder.DropTable(
//                name: "kategories");
//        }
//    }
//}
