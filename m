Return-Path: <metan@suse.de>
Date: Tue, 20 Nov 2018 17:42:49 +0100
From: Cyril Hrubis <chrubis@suse.cz>
Subject: Re: [LTP] [PATCH v3 2/6] syscalls/readahead02: Convert to newlib and
 cleanup
Message-ID: <20181120164249.GA19952@rei.lan>
References: <20181010233441.5337-1-amir73il@gmail.com>
 <20181010233441.5337-3-amir73il@gmail.com>
 <20181120160751.GA18182@rei.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181120160751.GA18182@rei.lan>
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org, ltp@lists.linux.it, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

Hi!
> >  #if defined(__NR_readahead)

Also we do have fallback definitions in lapi/syscalls.h, so
__NR_readahead is never undefined, we can safely drop this ifdef.

-- 
Cyril Hrubis
chrubis@suse.cz
