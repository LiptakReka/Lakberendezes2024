using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Lakberendezes.Migrations
{
    /// <inheritdoc />
    public partial class Correction : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {


            migrationBuilder.DropIndex(
                name: "IX_planproducts_userplanid",
                table: "planproducts");

            migrationBuilder.CreateIndex(
                name: "IX_planproducts_productid",
                table: "planproducts",
                column: "productid");

            migrationBuilder.AddForeignKey(
                name: "FK_planproducts_products_productid",
                table: "planproducts",
                column: "productid",
                principalTable: "products",
                principalColumn: "id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_planproducts_products_productid",
                table: "planproducts");

            migrationBuilder.DropIndex(
                name: "IX_planproducts_productid",
                table: "planproducts");

            migrationBuilder.CreateIndex(
                name: "IX_planproducts_userplanid",
                table: "planproducts",
                column: "userplanid");

            migrationBuilder.AddForeignKey(
                name: "FK_planproducts_products_userplanid",
                table: "planproducts",
                column: "userplanid",
                principalTable: "products",
                principalColumn: "id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
