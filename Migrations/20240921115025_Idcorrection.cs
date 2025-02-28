using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Lakberendezes.Migrations
{
    /// <inheritdoc />
    public partial class Idcorrection : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_planproducts_userplan_Userplansid",
                table: "planproducts");

            migrationBuilder.DropIndex(
                name: "IX_planproducts_Userplansid",
                table: "planproducts");

            migrationBuilder.DropColumn(
                name: "Userplansid",
                table: "planproducts");
        }

            //migrationBuilder.CreateIndex(
            //    name: "IX_planproducts_userplanid",
            //    table: "planproducts",
            //    column: "userplanid");

        //    migrationBuilder.AddForeignKey(
        //        name: "FK_planproducts_userplan_userplanid",
        //        table: "planproducts",
        //        column: "userplanid",
        //        principalTable: "userplan",
        //        principalColumn: "id",
        //        onDelete: ReferentialAction.Cascade);
        //}

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_planproducts_userplan_userplanid",
                table: "planproducts");

            //migrationBuilder.DropIndex(
            //    name: "IX_planproducts_userplanid",
            //    table: "planproducts");

            migrationBuilder.AddColumn<int>(
                name: "Userplansid",
                table: "planproducts",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_planproducts_Userplansid",
                table: "planproducts",
                column: "Userplansid");

            migrationBuilder.AddForeignKey(
                name: "FK_planproducts_userplan_Userplansid",
                table: "planproducts",
                column: "Userplansid",
                principalTable: "userplan",
                principalColumn: "id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
