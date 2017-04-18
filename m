From: "J . Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 2/4] src/open_by_handle: flexible usage options
Date: Tue, 18 Apr 2017 15:35:19 -0400
Message-ID: <20170418193519.GL6208@fieldses.org>
References: <1492539444-25938-1-git-send-email-amir73il@gmail.com>
 <1492539444-25938-3-git-send-email-amir73il@gmail.com>
 <20170418191417.GJ6208@fieldses.org>
 <CAOQ4uxiXmx9N_y3gHGXxtBM8bySwG_GaeGRBjX4qNf1tyGzUcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:36048 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755272AbdDRTfU (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 18 Apr 2017 15:35:20 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiXmx9N_y3gHGXxtBM8bySwG_GaeGRBjX4qNf1tyGzUcA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Trond Myklebust <trondmy@primarydata.com>, Jeff Layton <jlayton@poochiereds.net>, fstests <fstests@vger.kernel.org>, linux-unionfs@vger.kernel.org

On Tue, Apr 18, 2017 at 10:22:20PM +0300, Amir Goldstein wrote:
> On Tue, Apr 18, 2017 at 10:14 PM, J . Bruce Fields <bfields@fieldses.org> wrote:
> > On Tue, Apr 18, 2017 at 09:17:22PM +0300, Amir Goldstein wrote:
> >> More usage options for testing open_by_handle, which are needed
> >> for testing stable handles across copy up in overlayfs.
> >>
> >> usage: open_by_handle [-c|-l|-u|-d] <test_dir> [num_files]
> >>
> >> Examples:
> >>
> >> 1. Create N test files (nlink=1) under test_dir and exit:
> >>  $ open_by_handle -c <test_dir> [N]
> >>
> >> 2. Get file handles, drop caches and try to open by handle
> >>    (expects success):
> >>  $ open_by_handle <test_dir> [N]
> >>
> >> 3. Get file handles, create hardlinks to test files (nlink=2),
> >>    drop caches and try to open by handle (expects success):
> >>  $ open_by_handle -l <test_dir> [N]
> >
> > I guess I don't see the point of this particular test case.  It might be
> > more interesting if it then unlinked the original names, to test for the
> > case when a filesystem depends on the filename or parent directory being
> > encoded in the filehandle?
> >
> > Or maybe you are doing that in one of these tests, I'm not sure I follow
> > the descriptions.
> >
> 
> I am doing that, but with 2 separate invocations:
> open_by_handle -l <test_dir> [N]
> open_by_handle -u <test_dir> [N]

Oh, got it, I forgot these were building blocks for tests and not tests
in themselves....

> -u differs from -d because it expects the handle to be opened.
> 
> The reason I separated -l (link) and -u (unlink) is because
> for overlayfs I need to test linking in lower layer and unlinking
> from overlay.
> 
> I guess my intentions will become more clear after I post some
> overlay specific tests.
> It's kind of weird for me to post these tests when overlay
> doesn't have exportfs support yet, but I may do it anyway.

I don't think the filehandle lookup code has very good test coverage, so
it's probably useful to have anyway, thanks for working on this.

--b.

> >> 4. Get file handles, unlink test files w/o the hardlinks (nlink=1),
> >>    drop caches and try to open by handle (expects success):
> >>  $ open_by_handle -u <test_dir> [N]
> >>
> >> 5. Get file handles, unlink test files and hardlinks (nlink=0),
> >>    drop caches and try to open by handle (expects failure):
> >>  $ open_by_handle -d <test_dir> [N]
> >>
> >> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >> ---
> >>  src/open_by_handle.c | 93 ++++++++++++++++++++++++++++++++++++++++++++--------
> >>  1 file changed, 80 insertions(+), 13 deletions(-)
> >>
> >> diff --git a/src/open_by_handle.c b/src/open_by_handle.c
> >> index 8f04865..c33a4aa 100644
> >> --- a/src/open_by_handle.c
> >> +++ b/src/open_by_handle.c
> >> @@ -37,12 +37,12 @@
> >>  #include <errno.h>
> >>  #include <linux/limits.h>
> >>
> >> -#define NUMFILES 1024
> >> +#define MAXFILES 1024
> >>
> >>  struct handle {
> >>       struct file_handle fh;
> >>       unsigned char fid[MAX_HANDLE_SZ];
> >> -} handle[NUMFILES];
> >> +} handle[MAXFILES];
> >>
> >>  int main(int argc, char **argv)
> >>  {
> >> @@ -51,18 +51,60 @@ int main(int argc, char **argv)
> >>       int     ret;
> >>       int     failed = 0;
> >>       char    fname[PATH_MAX];
> >> +     char    fname2[PATH_MAX];
> >>       char    *test_dir;
> >>       int     mount_fd, mount_id;
> >> +     int     argi = 1, numfiles = 1;
> >> +     int     create = 0, delete = 0, nlink = 1;
> >>
> >> -     if (argc != 2) {
> >> -             fprintf(stderr, "usage: open_by_handle <test_dir>\n");
> >> +     if (argc < 2 || argc > 4) {
> >> +usage:
> >> +             fprintf(stderr, "usage: open_by_handle [-c|-l|-u|-d] <test_dir> [num_files]\n");
> >> +             fprintf(stderr, "\n");
> >> +             fprintf(stderr, "open_by_handle -c <test_dir> [N] - create N test files under test_dir, get file handles and exit\n");
> >> +             fprintf(stderr, "open_by_handle    <test_dir> [N] - get file handles, drop caches and try to open by handle (expects success)\n");
> >> +             fprintf(stderr, "open_by_handle -l <test_dir> [N] - get file handles, create hardlinks to test files (nlink=2), drop caches and try to open by handle (expects success)\n");
> >> +             fprintf(stderr, "open_by_handle -u <test_dir> [N] - get file handles, unlink test files w/o hardlinks (nlink=1), drop caches and try to open by handle (expects success)\n");
> >> +             fprintf(stderr, "open_by_handle -d <test_dir> [N] - get file handles, unlink test files and hardlinks (nlink=0), drop caches and try to open by handle (expects failure)\n");
> >>               return EXIT_FAILURE;
> >>       }
> >>
> >> -     test_dir = argv[1];
> >> +     if (argv[1][0] == '-') {
> >> +             if (argv[1][2])
> >> +                     goto usage;
> >> +             switch (argv[1][1]) {
> >> +             case 'c':
> >> +                     create = 1;
> >> +                     break;
> >> +             case 'l':
> >> +                     nlink = 2;
> >> +                     break;
> >> +             case 'u':
> >> +                     delete = 1;
> >> +                     nlink = 1;
> >> +                     break;
> >> +             case 'd':
> >> +                     delete = 1;
> >> +                     nlink = 0;
> >> +                     break;
> >> +             default:
> >> +                     fprintf(stderr, "illegal option '%s'\n", argv[1]);
> >> +             case 'h':
> >> +                     goto usage;
> >> +             }
> >> +             argi++;
> >> +     }
> >> +     test_dir = argv[argi++];
> >> +     if (argc > argi)
> >> +             numfiles = atoi(argv[argi]);
> >> +     if (!numfiles || numfiles > MAXFILES) {
> >> +             fprintf(stderr, "illegal value '%s' for num_files\n", argv[argi]);
> >> +             goto usage;
> >> +     }
> >> +
> >>       mount_fd = open(test_dir, O_RDONLY|O_DIRECTORY);
> >>       if (mount_fd < 0) {
> >> -             perror("open test_dir");
> >> +             perror(test_dir);
> >>               return EXIT_FAILURE;
> >>       }
> >>
> >> @@ -70,8 +112,9 @@ int main(int argc, char **argv)
> >>        * create a large number of files to force allocation of new inode
> >>        * chunks on disk.
> >>        */
> >> -     for (i=0; i < NUMFILES; i++) {
> >> +     for (i=0; create && i < numfiles; i++) {
> >>               sprintf(fname, "%s/file%06d", test_dir, i);
> >> +             sprintf(fname2, "%s/link%06d", test_dir, i);
> >>               fd = open(fname, O_RDWR | O_CREAT | O_TRUNC, 0644);
> >>               if (fd < 0) {
> >>                       printf("Warning (%s,%d), open(%s) failed.\n", __FILE__, __LINE__, fname);
> >> @@ -79,13 +122,14 @@ int main(int argc, char **argv)
> >>                       return EXIT_FAILURE;
> >>               }
> >>               close(fd);
> >> +             ret = unlink(fname2);
> >>       }
> >>
> >>       /* sync to get the new inodes to hit the disk */
> >>       sync();
> >>
> >>       /* create the handles */
> >> -     for (i=0; i < NUMFILES; i++) {
> >> +     for (i=0; i < numfiles; i++) {
> >>               sprintf(fname, "%s/file%06d", test_dir, i);
> >>               handle[i].fh.handle_bytes = MAX_HANDLE_SZ;
> >>               ret = name_to_handle_at(AT_FDCWD, fname, &handle[i].fh, &mount_id, 0);
> >> @@ -95,14 +139,32 @@ int main(int argc, char **argv)
> >>               }
> >>       }
> >>
> >> +     /* after creating test set only check that fs supports exportfs */
> >> +     if (create)
> >> +             return EXIT_SUCCESS;
> >> +
> >> +     /* hardlink the files */
> >> +     for (i=0; nlink > 1 && i < numfiles; i++) {
> >> +             sprintf(fname, "%s/file%06d", test_dir, i);
> >> +             sprintf(fname2, "%s/link%06d", test_dir, i);
> >> +             ret = link(fname, fname2);
> >> +             if (ret < 0) {
> >> +                     perror("link");
> >> +                     return EXIT_FAILURE;
> >> +             }
> >> +     }
> >> +
> >>       /* unlink the files */
> >> -     for (i=0; i < NUMFILES; i++) {
> >> +     for (i=0; delete && i < numfiles; i++) {
> >>               sprintf(fname, "%s/file%06d", test_dir, i);
> >> +             sprintf(fname2, "%s/link%06d", test_dir, i);
> >>               ret = unlink(fname);
> >>               if (ret < 0) {
> >>                       perror("unlink");
> >>                       return EXIT_FAILURE;
> >>               }
> >> +             if (!nlink)
> >> +                     ret = unlink(fname2);
> >>       }
> >>
> >>       /* sync to get log forced for unlink transactions to hit the disk */
> >> @@ -126,17 +188,22 @@ int main(int argc, char **argv)
> >>        * now try to open the files by the stored handles. Expecting ENOENT
> >>        * for all of them.
> >>        */
> >> -     for (i=0; i < NUMFILES; i++) {
> >> +     for (i=0; i < numfiles; i++) {
> >>               errno = 0;
> >>               fd = open_by_handle_at(mount_fd, &handle[i].fh, O_RDWR);
> >> -             if (fd < 0 && (errno == ENOENT || errno == ESTALE)) {
> >> +             if (nlink && fd >= 0) {
> >> +                     close(fd);
> >> +                     continue;
> >> +             } else if (!nlink && fd < 0 && (errno == ENOENT || errno == ESTALE)) {
> >>                       continue;
> >>               }
> >>               if (fd >= 0) {
> >>                       printf("open_by_handle(%d) opened an unlinked file!\n", i);
> >>                       close(fd);
> >> -             } else
> >> -                     printf("open_by_handle(%d) returned %d incorrectly on an unlinked file!\n", i, errno);
> >> +             } else {
> >> +                     printf("open_by_handle(%d) returned %d incorrectly on %s file!\n", i, errno,
> >> +                                     nlink ? "a linked" : "an unlinked");
> >> +             }
> >>               failed++;
> >>       }
> >>       if (failed)
> >> --
> >> 2.7.4
