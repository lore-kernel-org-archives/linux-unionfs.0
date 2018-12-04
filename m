Return-Path: <metan@suse.de>
Date: Tue, 4 Dec 2018 15:02:54 +0100
From: Cyril Hrubis <chrubis@suse.cz>
Subject: Re: [PATCH v4 5/6] syscalls/readahead02: test readahead() on an
 overlayfs file
Message-ID: <20181204140253.GA24114@rei.lan>
References: <20181128164645.783-1-amir73il@gmail.com>
 <20181128164645.783-6-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128164645.783-6-amir73il@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: ltp@lists.linux.it, Jan Stancek <jstancek@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Hi!
> The new test case is a regression test for kernel commit b833a3660394
> ("ovl: add ovl_fadvise()") which fixes a regression of readahead() on
> an overlay file that was introduced by kernel commit 5b910bd615ba
> ("ovl: fix GPF in swapfile_activate of file from overlayfs over xfs").

I've pushed the patches up to this patch with the change to the error
propagation as we agreed and:

* Added commit hashes of the two commits mentioned in this changelog
  to the top level comment of this test, since this is the place where
  testers look first for this kind of information.

+ Added one simplification patch on the top of this

I will look closer at the last one now.

Thanks for your work on the test.

-- 
Cyril Hrubis
chrubis@suse.cz
