import { redirect } from "@sveltejs/kit";
import type { Actions, PageServerLoad } from "./$types";
import { auth } from "$lib/server/auth";
import { db } from "$lib/server/db";

export const actions: Actions = {
  signOut: async (event) => {
    await auth.api.signOut({
      headers: event.request.headers,
    });
    return redirect(302, "/login");
  },
};

export const load: PageServerLoad = async (event) => {
  if (!event.locals.user) {
    return redirect(302, "/login");
  }

  const employees = await db.query.employee.findMany({
    where: (emp, { eq }) => eq(emp.companyId, event.locals.user.companyId),

  with: {
    department: {
      columns: {
        id: true,
        name: true,
        parentDepartmentId: true,
      },
      with: {
        parentDepartment: {
          columns: {
            name: true,
          },
        },
      },
    },
    position: true,
  },
  });

  return { employees };
};
