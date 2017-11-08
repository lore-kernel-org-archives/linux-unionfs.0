From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 2/7] open_by_handle: test file handles of renamed files
Date: Wed, 8 Nov 2017 08:11:29 +0200
Message-ID: <CAOQ4uxg_f-Gg8GoGRq9LJ8vRMAzQog8s2nxfKgPzHvEHKbbsHw@mail.gmail.com>
References: <1509617739-15744-1-git-send-email-amir73il@gmail.com>
 <1509617739-15744-3-git-send-email-amir73il@gmail.com> <20171108041008.GL17339@eguan.usersys.redhat.com>
 <20171108050745.GM17339@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:47035 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753783AbdKHGLa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Nov 2017 01:11:30 -0500
In-Reply-To: <20171108050745.GM17339@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Wed, Nov 8, 2017 at 7:07 AM, Eryu Guan <eguan@redhat.com> wrote:
> On Wed, Nov 08, 2017 at 12:10:08PM +0800, Eryu Guan wrote:
>> On Thu, Nov 02, 2017 at 12:15:34PM +0200, Amir Goldstein wrote:
>> > usage: open_by_handle -m <test_dir> [N]
>> >
>> > Get file handles for existing test set, rename all test files,
>> > drop cache and try to open all files by handle.
>> >
>> > This is needed for testing that overlayfs can find the upper
>> > inode from lower file handle even when upper is not in the same
>> > path as lower.
>> >
>> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> > ---
>> >  src/open_by_handle.c | 31 ++++++++++++++++++++++++++-----
>> >  1 file changed, 26 insertions(+), 5 deletions(-)
>> >
>> > diff --git a/src/open_by_handle.c b/src/open_by_handle.c
>> > index 52973c6..8b12df3 100644
>> > --- a/src/open_by_handle.c
>> > +++ b/src/open_by_handle.c
>> > @@ -27,7 +27,7 @@
>> >
>> >  /*
>> >
>> > -usage: open_by_handle [-c|-l|-u|-d] <test_dir> [num_files]
>> > +usage: open_by_handle [-cludm] <test_dir> [num_files]
>> >
>> >  Examples:
>> >
>> > @@ -48,7 +48,12 @@ Examples:
>> >
>> >     open_by_handle -d <test_dir> [N]
>> >
>> > -4. Get file handles for existing test set, hardlink all test files,
>> > +4. Get file handles for existing test set, rename all test files,
>> > +   drop caches, try to open all files by handle (should work):
>> > +
>> > +   open_by_handle -m <test_dir> [N]
>> > +
>> > +5. Get file handles for existing test set, hardlink all test files,
>> >     then unlink the original files, drop caches and try to open all
>> >     files by handle (should work):
>> >
>> > @@ -84,13 +89,14 @@ struct handle {
>> >
>> >  void usage(void)
>> >  {
>> > -   fprintf(stderr, "usage: open_by_handle [-c|-l|-u|-d] <test_dir> [num_files]\n");
>> > +   fprintf(stderr, "usage: open_by_handle [-cludm] <test_dir> [num_files]\n");
>> >     fprintf(stderr, "\n");
>> >     fprintf(stderr, "open_by_handle -c <test_dir> [N] - create N test files under test_dir, try to get file handles and exit\n");
>> >     fprintf(stderr, "open_by_handle    <test_dir> [N] - get file handles of test files, drop caches and try to open by handle\n");
>> >     fprintf(stderr, "open_by_handle -l <test_dir> [N] - create hardlinks to test files, drop caches and try to open by handle\n");
>> >     fprintf(stderr, "open_by_handle -u <test_dir> [N] - unlink (hardlinked) test files, drop caches and try to open by handle\n");
>> >     fprintf(stderr, "open_by_handle -d <test_dir> [N] - unlink test files and hardlinks, drop caches and try to open by handle\n");
>> > +   fprintf(stderr, "open_by_handle -m <test_dir> [N] - rename test files, drop caches and try to open by handle\n");
>> >     exit(EXIT_FAILURE);
>> >  }
>> >
>> > @@ -105,12 +111,12 @@ int main(int argc, char **argv)
>> >     char    *test_dir;
>> >     int     mount_fd, mount_id;
>> >     int     numfiles = 1;
>> > -   int     create = 0, delete = 0, nlink = 1;
>> > +   int     create = 0, delete = 0, nlink = 1, move = 0;
>> >
>> >     if (argc < 2 || argc > 4)
>> >             usage();
>> >
>> > -   while ((c = getopt(argc, argv, "clud")) != -1) {
>> > +   while ((c = getopt(argc, argv, "cludm")) != -1) {
>> >             switch (c) {
>> >             case 'c':
>> >                     create = 1;
>> > @@ -126,6 +132,9 @@ int main(int argc, char **argv)
>> >                     delete = 1;
>> >                     nlink = 0;
>> >                     break;
>> > +           case 'm':
>> > +                   move = 1;
>> > +                   break;
>> >             default:
>> >                     fprintf(stderr, "illegal option '%s'\n", argv[optind]);
>> >             case 'h':
>> > @@ -201,6 +210,18 @@ int main(int argc, char **argv)
>> >             }
>> >     }
>> >
>> > +   /* rename the files */
>> > +   for (i=0; move && i < numfiles; i++) {
>> > +           sprintf(fname, "%s/file%06d", test_dir, i);
>> > +           sprintf(fname2, "%s/link%06d", test_dir, i);
>>
>> Should we choose another prefix for moved files? "link" is used for
>> hardlink files already, use something like "move"? (I can fix it up if
>> you agree to do so.)
>
> Ah, seems this is not a trivial fixup as I thought, patch 4 depends on
> the file name prefix of moved files to be "link" too.
>

Move is very similar to link+unlink origin in the context of this test,
to the point that nfsd wouldn't be able to tell the difference between
the two cases.
When it is time to decode the file handle, in both cases there is
nlink == 1 and origin file path is unlinked.

Amir.
