From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [RFC PATCH 1/5] ovl: document permission model
Date: Fri, 25 Oct 2019 13:29:13 +0200
Message-ID: <20191025112917.22518-2-mszeredi@redhat.com>
References: <20191025112917.22518-1-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191025112917.22518-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Add missing piece of documentation regarding how permissions are checked in
overlayfs.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 Documentation/filesystems/overlayfs.txt | 44 +++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesy=
stems/overlayfs.txt
index 845d689e0fd7..674fc8b1e420 100644
--- a/Documentation/filesystems/overlayfs.txt
+++ b/Documentation/filesystems/overlayfs.txt
@@ -246,6 +246,50 @@ overlay filesystem (though an operation on the name of=
 the file such as
 rename or unlink will of course be noticed and handled).
=20
=20
+Permission model
+----------------
+
+Permission checking in the overlay filesystem follows these principles:
+
+ 1) permission check SHOULD return the same result before and after copy u=
p
+
+ 2) task creating the overlay mount MUST NOT gain additional privileges
+
+ 3) non-mounting task MAY gain additional privileges through the overlay,
+ compared to direct access on underlying lower or upper filesystems
+
+This is achieved by performing two permission checks on each access
+
+ a) check if current task is allowed access based on local DAC (owner,
+    group, mode and posix acl), as well as MAC checks
+
+ b) check if mounting task would be allowed real operation on lower or
+    upper layer based on underlying filesystem permissions, again includin=
g
+    MAC checks
+
+Check (a) ensures consistency (1) since owner, group, mode and posix acls
+are copied up.  On the other hand it can result in server enforced
+permissions (used by NFS, for example) being ignored (3).
+
+Check (b) ensures that no task gains permissions to underlying layers that
+the mounting task does not have (2).  This also means that it is possible
+to create setups where the consistency rule (1) does not hold; normally,
+however, the mounting task will have sufficient privileges to perform all
+operations.
+
+Another way to demonstrate this model is drawing parallels between
+
+  mount -t overlay overlay -olowerdir=3D/lower,upperdir=3D/upper,... /merg=
ed
+
+and
+
+  cp -a /lower /upper
+  mount --bind /upper /merged
+
+The resulting access permissions should be the same.  The difference is in
+the time of copy (on-demand vs. up-front).
+
+
 Multiple lower layers
 ---------------------
=20
--=20
2.21.0
