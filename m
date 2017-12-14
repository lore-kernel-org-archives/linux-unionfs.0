From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH v2 14/18] fsck.overlay: correct copyright and License
Date: Thu, 14 Dec 2017 14:47:43 +0800
Message-ID: <20171214064747.20999-15-yi.zhang@huawei.com>
References: <20171214064747.20999-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:11989 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751305AbdLNGmH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Dec 2017 01:42:07 -0500
In-Reply-To: <20171214064747.20999-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, darrick.wong@oracle.com, yi.zhang@huawei.com, miaoxie@huawei.com

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 check.c  | 17 +++++++++++++++--
 check.h  | 18 ++++++++++++++++++
 common.c | 16 ++++++++++++++--
 common.h | 18 ++++++++++++++++++
 config.h | 18 ++++++++++++++++++
 fsck.c   | 17 +++++++++++++++--
 lib.c    | 17 +++++++++++++++--
 lib.h    | 18 ++++++++++++++++++
 mount.c  | 17 +++++++++++++++--
 mount.h  | 18 ++++++++++++++++++
 10 files changed, 164 insertions(+), 10 deletions(-)

diff --git a/check.c b/check.c
index ca75358..7e07b66 100644
--- a/check.c
+++ b/check.c
@@ -1,11 +1,24 @@
 /*
+ * check.c - Check and fix inconsistency for all underlying layers of overlay
  *
- *	Check and fix inconsistency for all underlying layers of overlay
+ * Copyright (c) 2017 Huawei.  All Rights Reserved.
+ * Author: zhangyi (F) <yi.zhang@huawei.com>
  *
- * 	zhangyi (F) <yi.zhang@huawei.com> - Sponsored by Huawei CR
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
  *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+
 #define _GNU_SOURCE
 #include <stdlib.h>
 #include <stdio.h>
diff --git a/check.h b/check.h
index 373ff3a..6af8c2d 100644
--- a/check.h
+++ b/check.h
@@ -1,3 +1,21 @@
+/*
+ * Copyright (c) 2017 Huawei.  All Rights Reserved.
+ * Author: zhangyi (F) <yi.zhang@huawei.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
 #ifndef OVL_WHITECHECK_H
 #define OVL_WHITECHECK_H
 
diff --git a/common.c b/common.c
index 4e77045..904db58 100644
--- a/common.c
+++ b/common.c
@@ -1,9 +1,21 @@
 /*
+ * common.c - Common things for all utilities
  *
- *	Common things for all utilities
+ * Copyright (c) 2017 Huawei.  All Rights Reserved.
+ * Author: zhangyi (F) <yi.zhang@huawei.com>
  *
- *	zhangyi (F) <yi.zhang@huawei.com> - Sponsored by Huawei CR
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
  *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
 #include <stdio.h>
diff --git a/common.h b/common.h
index c4707e7..c93b7a6 100644
--- a/common.h
+++ b/common.h
@@ -1,3 +1,21 @@
+/*
+ * Copyright (c) 2017 Huawei.  All Rights Reserved.
+ * Author: zhangyi (F) <yi.zhang@huawei.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
 #ifndef OVL_COMMON_H
 #define OVL_COMMON_H
 
diff --git a/config.h b/config.h
index deac089..fa7eafa 100644
--- a/config.h
+++ b/config.h
@@ -1,3 +1,21 @@
+/*
+ * Copyright (c) 2017 Huawei.  All Rights Reserved.
+ * Author: zhangyi (F) <yi.zhang@huawei.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
 #ifndef OVL_CONFIG_H
 #define OVL_CONFIG_H
 
diff --git a/fsck.c b/fsck.c
index 0a84903..56a5286 100644
--- a/fsck.c
+++ b/fsck.c
@@ -1,11 +1,24 @@
 /*
+ * fsck.c - Utility to fsck overlay
  *
- *	Utility to fsck overlay
+ * Copyright (c) 2017 Huawei.  All Rights Reserved.
+ * Author: zhangyi (F) <yi.zhang@huawei.com>
  *
- * 	zhangyi (F) <yi.zhang@huawei.com> - Sponsored by Huawei CR
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
  *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
diff --git a/lib.c b/lib.c
index 7495af5..00ec81f 100644
--- a/lib.c
+++ b/lib.c
@@ -1,11 +1,24 @@
 /*
+ * lib.c - Common things for all utilities
  *
- *	Common things for all utilities
+ * Copyright (c) 2017 Huawei.  All Rights Reserved.
+ * Author: zhangyi (F) <yi.zhang@huawei.com>
  *
- * 	zhangyi (F) <yi.zhang@huawei.com> - Sponsored by Huawei CR
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
  *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+
 #include <stdlib.h>
 #include <stdio.h>
 #include <unistd.h>
diff --git a/lib.h b/lib.h
index 0f0b526..ebcc77c 100644
--- a/lib.h
+++ b/lib.h
@@ -1,3 +1,21 @@
+/*
+ * Copyright (c) 2017 Huawei.  All Rights Reserved.
+ * Author: zhangyi (F) <yi.zhang@huawei.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
 #ifndef OVL_LIB_H
 #define OVL_LIB_H
 
diff --git a/mount.c b/mount.c
index 768c7aa..10970d5 100644
--- a/mount.c
+++ b/mount.c
@@ -1,11 +1,24 @@
 /*
+ * mount.c - Check mounted overlay
  *
- *	Check mounted overlay
+ * Copyright (c) 2017 Huawei.  All Rights Reserved.
+ * Author: zhangyi (F) <yi.zhang@huawei.com>
  *
- * 	zhangyi (F) <yi.zhang@huawei.com> - Sponsored by Huawei CR
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
  *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
diff --git a/mount.h b/mount.h
index 8a3762d..e65425c 100644
--- a/mount.h
+++ b/mount.h
@@ -1,3 +1,21 @@
+/*
+ * Copyright (c) 2017 Huawei.  All Rights Reserved.
+ * Author: zhangyi (F) <yi.zhang@huawei.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
 #ifndef OVL_MOUNT_H
 #define OVL_MOUNT_H
 
-- 
2.9.5
