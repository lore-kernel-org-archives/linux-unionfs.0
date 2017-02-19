From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/9] overlay: fix inconsistency of ro file after copy-up
Date: Sun, 19 Feb 2017 09:14:41 +0000
Message-ID: <20170219091430.GL29622@ZenIV.linux.org.uk>
References: <1487347778-18596-1-git-send-email-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1487347778-18596-1-git-send-email-mszeredi@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Fri, Feb 17, 2017 at 05:09:29PM +0100, Miklos Szeredi wrote:
> A file is opened for read-only, opened read-write (resulting in a copy up)
> and modified.  The data read back from the the read-only fd will be stale
> in this case (the read-only file descriptor still refers to the lower,
> unmodified file).
> 
> This patchset fixes issues related to this corner case.  This is a
> requirement from various parties for accepting overlayfs as a "POSIX"
> filesystem.
> 
> When an operation (read, mmap, fsync) is done on an overlay fd opened
> read-only that is referring to a lower file, check if it has been copied up
> in the mean time.  If so, open the upper file and use that for the operation.
> 
> To make the performance impact minimal for non-overlay case, use a flag in
> file->f_mode to indicate that this is an overlay file.

This is one hell of a DoS vector - it's really easy to eat tons of struct
file that way.  Preparatory parts of that series make sense on their own,
but your "let's allocate a struct file, call ->open() and schedule that
struct file for closing upon the exit to userland on each kernel_read()"
is not.
