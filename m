Return-Path: <metan@suse.de>
Date: Mon, 3 Dec 2018 15:39:34 +0100
From: Cyril Hrubis <chrubis@suse.cz>
Subject: Re: [PATCH v4 1/6] syscalls/readahead02: Convert to newlib and
 cleanup
Message-ID: <20181203143934.GB4974@rei.lan>
References: <20181128164645.783-1-amir73il@gmail.com>
 <20181128164645.783-2-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128164645.783-2-amir73il@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: ltp@lists.linux.it, Jan Stancek <jstancek@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Hi!
> +static struct tst_test test = {
> +	.needs_root = 1,
> +	.needs_tmpdir = 1,
> +	.mount_device = 1,
> +	.mntpoint = mntpoint,
> +	.setup = setup,
> +	.options = options,
> +	.test_all = test_readahead,
> +};

I do wonder if it makes sense to set the all_filesystems flag now.

Also does it make any sense to run the overlay test against all
filesystems? I would expect that it does not, so we will have to figure
out how to run the tests. Maybe it would make most sense to treat the
overlayfs as another filesystem in all_filesystem tests...

-- 
Cyril Hrubis
chrubis@suse.cz
