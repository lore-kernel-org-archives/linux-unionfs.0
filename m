From: David Howells <dhowells@redhat.com>
Subject: [PATCH 12/15] VFS: Add owner-filesystem positive/negative dentry
 checks
Date: Wed, 25 Mar 2015 14:45:24 +0000
Message-ID: <20150325144524.17670.21070.stgit@warthog.procyon.org.uk>
References: <20150325144330.17670.6959.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150325144330.17670.6959.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@ftp.linux.org.uk
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu
List-Id: linux-unionfs@vger.kernel.org

Supply two functions to test whether a filesystem's own dentries are positive
or negative (d_really_is_positive() and d_really_is_negative()).

The problem is that the DCACHE_ENTRY_TYPE field of dentry->d_flags may be
overridden by the union part of a layered filesystem and isn't thus
necessarily indicative of the type of dentry.

Normally, this would involve a negative dentry (ie. ->d_inode == NULL) having
->d_layer.lower pointed to a lower layer dentry, DCACHE_PINNING_LOWER set and
the DCACHE_ENTRY_TYPE field set to something other than DCACHE_MISS_TYPE - but
it could also involve, say, a DCACHE_SPECIAL_TYPE being overridden to
DCACHE_WHITEOUT_TYPE if a 0,0 chardev is detected in the top layer.

However, inside a filesystem, when that fs is looking at its own dentries, it
probably wants to know if they are really negative or not - and doesn't care
about the fallthrough bits used by the union.

To this end, a filesystem should normally use d_really_is_positive/negative()
when looking at its own dentries rather than d_is_positive/negative() and
should use d_inode() to get at the inode.

Anyone looking at someone else's dentries (this includes pathwalk) should use
d_is_xxx() and d_backing_inode().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/dcache.h |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index d8358799c594..e83768ee38fc 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -482,6 +482,44 @@ static inline bool d_is_positive(const struct dentry *dentry)
 	return !d_is_negative(dentry);
 }
 
+/**
+ * d_really_is_negative - Determine if a dentry is really negative (ignoring fallthroughs)
+ * @dentry: The dentry in question
+ *
+ * Returns true if the dentry represents either an absent name or a name that
+ * doesn't map to an inode (ie. ->d_inode is NULL).  The dentry could represent
+ * a true miss, a whiteout that isn't represented by a 0,0 chardev or a
+ * fallthrough marker in an opaque directory.
+ *
+ * Note!  (1) This should be used *only* by a filesystem to examine its own
+ * dentries.  It should not be used to look at some other filesystem's
+ * dentries.  (2) It should also be used in combination with d_inode() to get
+ * the inode.  (3) The dentry may have something attached to ->d_lower and the
+ * type field of the flags may be set to something other than miss or whiteout.
+ */
+static inline bool d_really_is_negative(const struct dentry *dentry)
+{
+	return dentry->d_inode == NULL;
+}
+
+/**
+ * d_really_is_positive - Determine if a dentry is really positive (ignoring fallthroughs)
+ * @dentry: The dentry in question
+ *
+ * Returns true if the dentry represents a name that maps to an inode
+ * (ie. ->d_inode is not NULL).  The dentry might still represent a whiteout if
+ * that is represented on medium as a 0,0 chardev.
+ *
+ * Note!  (1) This should be used *only* by a filesystem to examine its own
+ * dentries.  It should not be used to look at some other filesystem's
+ * dentries.  (2) It should also be used in combination with d_inode() to get
+ * the inode.
+ */
+static inline bool d_really_is_positive(const struct dentry *dentry)
+{
+	return dentry->d_inode != NULL;
+}
+
 extern void d_set_fallthru(struct dentry *dentry);
 
 static inline bool d_is_fallthru(const struct dentry *dentry)
