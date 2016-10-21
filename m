From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [POC/RFC PATCH] overlayfs: fix data inconsistency at copy up
Date: Fri, 21 Oct 2016 16:13:35 -0400
Message-ID: <20161021201335.GB20129@redhat.com>
References: <20161012133326.GD31239@veci.piliscsaba.szeredi.hu>
 <20161020204630.GA1000@redhat.com>
 <20161020205408.GB1000@redhat.com>
 <CAOQ4uxh7cfh5ZtNX8hkeTuye6hRxbMpzZ4p9mGAn2z5rq3RGvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh7cfh5ZtNX8hkeTuye6hRxbMpzZ4p9mGAn2z5rq3RGvA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Jeremy Eder <jeder@redhat.com>, David Howells <dhowells@redhat.com>, Ratna Bolla <rbolla@portworx.com>, Gou Rao <grao@portworx.com>, Vinod Jayaraman <jv@portworx.com>, Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Oct 21, 2016 at 11:53:41AM +0300, Amir Goldstein wrote:
> On Thu, Oct 20, 2016 at 11:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Thu, Oct 20, 2016 at 04:46:30PM -0400, Vivek Goyal wrote:
> >
> > [..]
> >> > +static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *to)
> >> > +{
> >> > +   struct file *file = iocb->ki_filp;
> >> > +   bool isupper = OVL_TYPE_UPPER(ovl_path_type(file->f_path.dentry));
> >> > +   ssize_t ret = -EINVAL;
> >> > +
> >> > +   if (likely(!isupper)) {
> >> > +           const struct file_operations *fop = ovl_real_fop(file);
> >> > +
> >> > +           if (likely(fop->read_iter))
> >> > +                   ret = fop->read_iter(iocb, to);
> >> > +   } else {
> >> > +           struct file *upperfile = filp_clone_open(file);
> >> > +
> >>
> >> IIUC, every read of lower file will call filp_clone_open(). Looking at the
> >> code of filp_clone_open(), I am concerned about the overhead of this call.
> >> Is it significant? Don't want to be paying too much of penalty for read
> >> operation on lower files. That would be a common case for containers.
> >>
> >
> > Looks like I read the code in reverse. So if I open a file read-only,
> > and if it has not been copied up, I will simply call read_iter() on
> > lower filesystem. But if file has been copied up, then I will call
> > filp_clone_open() and pay the cost. And this will continue till this
> > file is closed by caller.
> >
> 
> I wonder if that cost could be reduced by calling replace_fd() or
> some variant of it to install the cloned file onto the rofd after the
> first access??

Hmm.., Interesting. Will something like following work? This applies on
top of Miklos's patch. It seems to work for me. It might be completely
broken/racy though. Somebody who understands this code well, will have
to have a look.

---
 fs/file.c            |   41 +++++++++++++++++++++++++++++++++++++++++
 fs/overlayfs/inode.c |    1 +
 2 files changed, 42 insertions(+)

Index: rhvgoyal-linux/fs/overlayfs/inode.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/inode.c	2016-10-21 15:43:05.391488406 -0400
+++ rhvgoyal-linux/fs/overlayfs/inode.c	2016-10-21 16:07:57.409420795 -0400
@@ -416,6 +416,7 @@ static ssize_t ovl_read_iter(struct kioc
 		if (IS_ERR(upperfile)) {
 			ret = PTR_ERR(upperfile);
 		} else {
+			replace_file(file, upperfile);
 			ret = vfs_iter_read(upperfile, to, &iocb->ki_pos);
 			fput(upperfile);
 		}
Index: rhvgoyal-linux/fs/file.c
===================================================================
--- rhvgoyal-linux.orig/fs/file.c	2016-10-21 15:43:05.391488406 -0400
+++ rhvgoyal-linux/fs/file.c	2016-10-21 16:08:18.168420795 -0400
@@ -864,6 +864,47 @@ Ebusy:
 	return -EBUSY;
 }
 
+
+int replace_file(struct file *old_file, struct file *new_file)
+{
+#define MAX_TO_FREE	8
+	int n, idx = 0;
+	struct files_struct *files = current->files;
+	struct fdtable *fdt;
+	struct file *to_free[MAX_TO_FREE];
+	bool retry = false;
+
+try_again:
+	spin_lock(&files->file_lock);
+	for (n = 0, fdt = files_fdtable(files); n < fdt->max_fds; n++) {
+                struct file *file;
+                file = rcu_dereference_check_fdtable(files, fdt->fd[n]);
+                if (!file)
+                        continue;
+		if (file == old_file) {
+			get_file(new_file);
+			rcu_assign_pointer(fdt->fd[n], new_file);
+			to_free[idx++] = file;
+			if (idx >= MAX_TO_FREE) {
+				retry = true;
+				break;
+			}
+		}
+        }
+	spin_unlock(&files->file_lock);
+	while (idx) {
+		filp_close(to_free[--idx], files);
+	}
+
+	if (retry) {
+		retry = false;
+		idx = 0;
+		goto try_again;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(replace_file);
+
 int replace_fd(unsigned fd, struct file *file, unsigned flags)
 {
 	int err;
