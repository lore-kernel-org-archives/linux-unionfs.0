From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 2/2] iomap: partially revert
 4721a601099 (simulated directio short read on EFAULT)
Date: Wed, 28 Aug 2019 07:23:32 -0700
Message-ID: <20190828142332.GT1037422@magnolia>
References: <20181202180832.GR8125@magnolia> <20181202181045.GS8125@magnolia>
	<CAHpGcM+WQYFHOOC8SzKq+=DuHVZ4fw4RHLTMUDN-o6GX3YtGvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAHpGcM+WQYFHOOC8SzKq+=DuHVZ4fw4RHLTMUDN-o6GX3YtGvQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
To: Andreas =?iso-8859-1?Q?Gr=FCnbacher?= <andreas.gruenbacher@gmail.com>
Cc: jencce.kernel@gmail.com, Zorro Lang <zlang@redhat.com>, Dave Chinner <david@fromorbit.com>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, cluster-devel <cluster-devel@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Aug 21, 2019 at 10:23:49PM +0200, Andreas Grünbacher wrote:
> Hi Darrick,
> 
> Am So., 2. Dez. 2018 um 19:13 Uhr schrieb Darrick J. Wong
> <darrick.wong@oracle.com>:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > In commit 4721a601099, we tried to fix a problem wherein directio reads
> > into a splice pipe will bounce EFAULT/EAGAIN all the way out to
> > userspace by simulating a zero-byte short read.  This happens because
> > some directio read implementations (xfs) will call
> > bio_iov_iter_get_pages to grab pipe buffer pages and issue asynchronous
> > reads, but as soon as we run out of pipe buffers that _get_pages call
> > returns EFAULT, which the splice code translates to EAGAIN and bounces
> > out to userspace.
> >
> > In that commit, the iomap code catches the EFAULT and simulates a
> > zero-byte read, but that causes assertion errors on regular splice reads
> > because xfs doesn't allow short directio reads.  This causes infinite
> > splice() loops and assertion failures on generic/095 on overlayfs
> > because xfs only permit total success or total failure of a directio
> > operation.  The underlying issue in the pipe splice code has now been
> > fixed by changing the pipe splice loop to avoid avoid reading more data
> > than there is space in the pipe.
> >
> > Therefore, it's no longer necessary to simulate the short directio, so
> > remove the hack from iomap.
> >
> > Fixes: 4721a601099 ("iomap: dio data corruption and spurious errors when pipes fill")
> > Reported-by: Amir Goldstein <amir73il@gmail.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v2: split into two patches per hch request
> > ---
> >  fs/iomap.c |    9 ---------
> >  1 file changed, 9 deletions(-)
> >
> > diff --git a/fs/iomap.c b/fs/iomap.c
> > index 3ffb776fbebe..d6bc98ae8d35 100644
> > --- a/fs/iomap.c
> > +++ b/fs/iomap.c
> > @@ -1877,15 +1877,6 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> >                                 dio->wait_for_completion = true;
> >                                 ret = 0;
> >                         }
> > -
> > -                       /*
> > -                        * Splicing to pipes can fail on a full pipe. We have to
> > -                        * swallow this to make it look like a short IO
> > -                        * otherwise the higher splice layers will completely
> > -                        * mishandle the error and stop moving data.
> > -                        */
> > -                       if (ret == -EFAULT)
> > -                               ret = 0;
> >                         break;
> >                 }
> >                 pos += ret;
> 
> I'm afraid this breaks the following test case on xfs and gfs2, the
> two current users of iomap_dio_rw.

Hmm, I had kinda wondered if regular pipes still needed this help.
Evidently we don't have a lot of splice tests in fstests. :(

> Here, the splice system call fails with errno = EAGAIN when trying to
> "move data" from a file opened with O_DIRECT into a pipe.
> 
> The test case can be run with option -d to not use O_DIRECT, which
> makes the test succeed.
> 
> The -r option switches from reading from the pipe sequentially to
> reading concurrently with the splice, which doesn't change the
> behavior.
> 
> Any thoughts?

This would be great as an xfstest! :)

Do you have one ready to go, or should I just make one from the source
code?

--D

> Thanks,
> Andreas
> 
> =================================== 8< ===================================
> #define _GNU_SOURCE
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <sys/wait.h>
> #include <unistd.h>
> #include <fcntl.h>
> #include <err.h>
> 
> #include <stdlib.h>
> #include <stdio.h>
> #include <stdbool.h>
> #include <string.h>
> #include <errno.h>
> 
> #define SECTOR_SIZE 512
> #define BUFFER_SIZE (150 * SECTOR_SIZE)
> 
> void read_from_pipe(int fd, const char *filename, size_t size)
> {
>     char buffer[SECTOR_SIZE];
>     size_t sz;
>     ssize_t ret;
> 
>     while (size) {
>         sz = size;
>         if (sz > sizeof buffer)
>             sz = sizeof buffer;
>         ret = read(fd, buffer, sz);
>         if (ret < 0)
>             err(1, "read: %s", filename);
>         if (ret == 0) {
>             fprintf(stderr, "read: %s: unexpected EOF\n", filename);
>             exit(1);
>         }
>         size -= sz;
>     }
> }
> 
> void do_splice1(int fd, const char *filename, size_t size)
> {
>     bool retried = false;
>     int pipefd[2];
> 
>     if (pipe(pipefd) == -1)
>         err(1, "pipe");
>     while (size) {
>         ssize_t spliced;
> 
>         spliced = splice(fd, NULL, pipefd[1], NULL, size, SPLICE_F_MOVE);
>         if (spliced == -1) {
>             if (errno == EAGAIN && !retried) {
>                 retried = true;
>                 fprintf(stderr, "retrying splice\n");
>                 sleep(1);
>                 continue;
>             }
>             err(1, "splice");
>         }
>         read_from_pipe(pipefd[0], filename, spliced);
>         size -= spliced;
>     }
>     close(pipefd[0]);
>     close(pipefd[1]);
> }
> 
> void do_splice2(int fd, const char *filename, size_t size)
> {
>     bool retried = false;
>     int pipefd[2];
>     int pid;
> 
>     if (pipe(pipefd) == -1)
>         err(1, "pipe");
> 
>     pid = fork();
>     if (pid == 0) {
>         close(pipefd[1]);
>         read_from_pipe(pipefd[0], filename, size);
>         exit(0);
>     } else {
>         close(pipefd[0]);
>         while (size) {
>             ssize_t spliced;
> 
>             spliced = splice(fd, NULL, pipefd[1], NULL, size, SPLICE_F_MOVE);
>             if (spliced == -1) {
>                 if (errno == EAGAIN && !retried) {
>                     retried = true;
>                     fprintf(stderr, "retrying splice\n");
>                     sleep(1);
>                     continue;
>                 }
>                 err(1, "splice");
>             }
>             size -= spliced;
>         }
>         close(pipefd[1]);
>         waitpid(pid, NULL, 0);
>     }
> }
> 
> void usage(const char *argv0)
> {
>     fprintf(stderr, "USAGE: %s [-rd] {filename}\n", basename(argv0));
>     exit(2);
> }
> 
> int main(int argc, char *argv[])
> {
>     void (*do_splice)(int fd, const char *filename, size_t size);
>     const char *filename;
>     char *buffer;
>     int opt, open_flags, fd;
>     ssize_t ret;
> 
>     do_splice = do_splice1;
>     open_flags = O_CREAT | O_TRUNC | O_RDWR | O_DIRECT;
> 
>     while ((opt = getopt(argc, argv, "rd")) != -1) {
>         switch(opt) {
>         case 'r':
>             do_splice = do_splice2;
>             break;
>         case 'd':
>             open_flags &= ~O_DIRECT;
>             break;
>         default:  /* '?' */
>             usage(argv[0]);
>         }
>     }
> 
>     if (optind >= argc)
>         usage(argv[0]);
>     filename = argv[optind];
> 
>     printf("%s reader %s O_DIRECT\n",
>            do_splice == do_splice1 ? "sequential" : "concurrent",
>            (open_flags & O_DIRECT) ? "with" : "without");
> 
>     buffer = aligned_alloc(SECTOR_SIZE, BUFFER_SIZE);
>     if (buffer == NULL)
>         err(1, "aligned_alloc");
> 
>     fd = open(filename, open_flags, 0666);
>     if (fd == -1)
>         err(1, "open: %s", filename);
> 
>     memset(buffer, 'x', BUFFER_SIZE);
>     ret = write(fd, buffer, BUFFER_SIZE);
>     if (ret < 0)
>         err(1, "write: %s", filename);
>     if (ret != BUFFER_SIZE) {
>         fprintf(stderr, "%s: short write\n", filename);
>         exit(1);
>     }
> 
>     ret = lseek(fd, 0, SEEK_SET);
>     if (ret != 0)
>         err(1, "lseek: %s", filename);
> 
>     do_splice(fd, filename, BUFFER_SIZE);
> 
>     if (unlink(filename) == -1)
>         err(1, "unlink: %s", filename);
> 
>     return 0;
> }
> =================================== 8< ===================================
