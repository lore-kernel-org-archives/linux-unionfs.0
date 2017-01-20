From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/2] overlayfs: support freeze/thaw/syncfs
Date: Fri, 20 Jan 2017 09:50:35 +0100
Message-ID: <20170120085035.GC14115@quack2.suse.cz>
References: <1484828008-27507-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484828008-27507-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi,

On Thu 19-01-17 14:13:26, Amir Goldstein wrote:
> I implemented freeze/thaw of overlayfs, because I need it for
> overlay snapshots (CoW decision is made before mnt_wat_write(upper)
> and I need to serialize it with snapshot take).
> 
> Not sure if there are other use cases for overlayfs freeze??
> 
> Tested freeze stress with xfstest generic/068 generic/390.
> 
> While staring at the code, I realized that syncfs(2) for overlayfs
> seems broken.  It looks like only inodes are synced and upper fs
> metadata is not being flushed, but I could be wrong.
> 
> Tested sync sanity with -g quick (although no test calls syncfs directly).
> Tested the usual unionmount sanity over xfs and over tmpfs.
> 
> I am not sure exactly how to write a test case to verify this alleged
> breakage?
> 
> Jan,
> 
> Can you please have a look?

So I don't really understand overlayfs but from my 10000 feet view your
changes make sense to me...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
