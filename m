Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37950 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725857AbeJHOVc (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 8 Oct 2018 10:21:32 -0400
Date: Mon, 8 Oct 2018 03:11:14 -0400 (EDT)
From: Jan Stancek <jstancek@redhat.com>
Message-ID: <1498422724.56763494.1538982674701.JavaMail.zimbra@redhat.com>
In-Reply-To: <20181004062624.27295-1-amir73il@gmail.com>
References: <20181004062624.27295-1-amir73il@gmail.com>
Subject: Re: [PATCH v2 0/5] Tests for readahead() and fadvise() on overlayfs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Cyril Hrubis <chrubis@suse.cz>, ltp@lists.linux.it, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>



----- Original Message -----
> Cyril,
> 
> The following series adds test covergae for readahead() syscall
> over overlayfs file and adds test coverage for a specific
> posix_fadvise() syscall advice (POSIX_FADV_WILLNEED).
> 
> So far, the posix_fadvise syscall tests in LTP only test for error
> conditions, but not functionality.
> 
> The functionality of the advice POSIX_FADV_WILLNEED is indentical
> to readahead() and since kernel commit 3d8f7615319b ("vfs: implement
> readahead(2) using POSIX_FADV_WILLNEED"), the implementations are
> also bound together.
> 
> To add test coverage of the advice POSIX_FADV_WILLNEED, I decided not
> to duplicate the readahead() functional test and add test cases to
> readahead02 that use the POSIX_FADV_WILLNEED implementation.
> 
> Thanks,
> Amir.
> 
> Changes since v1:
> - Fix bugs in loop invocation of test (i.e. -i 2)
> - Address review comments from Jan Stancek
> - Make cached_max a global maximum over all test cases
> - Improve reliability of overlayfs readahead test case failure

Looks good to me.

When you say "This is the only system configuration supported by the posix_fadvise tests",
are you talking about glibc?

Regards,
Jan

> 
> Amir Goldstein (5):
>   syscalls/readahead01: Convert to newlib
>   syscalls/readahead02: Convert to newlib and cleanup
>   syscalls/readahead02: test readahead() on an overlayfs file
>   syscalls/readahead02: test readahead using posix_fadvise()
>   syscalls/readahead02: fail test if readahead did not use any cache
> 
>  .../kernel/syscalls/readahead/readahead01.c   | 119 ++-----
>  .../kernel/syscalls/readahead/readahead02.c   | 333 +++++++++---------
>  2 files changed, 195 insertions(+), 257 deletions(-)
> 
> --
> 2.17.1
> 
> 
