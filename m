From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 09/11] vfs: factor out inode_insert5()
Date: Mon, 11 Jun 2018 17:43:55 +0100
Message-ID: <20180611164355.GV30522@ZenIV.linux.org.uk>
References: <20180529144143.16378-1-mszeredi@redhat.com>
 <20180529144143.16378-10-mszeredi@redhat.com>
 <20180610054902.GQ30522@ZenIV.linux.org.uk>
 <20180610060159.GS30522@ZenIV.linux.org.uk>
 <CAJfpegt5guR3zJeATw4-N41Ad2n9pcB5mQoLmSLOfocnEoodVg@mail.gmail.com>
 <20180611113230.GI23785@veci.piliscsaba.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180611113230.GI23785@veci.piliscsaba.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Mon, Jun 11, 2018 at 01:32:30PM +0200, Miklos Szeredi wrote:

> Incremental follows.  I think it's cleaner to initialize i_state and i_sb_list
> up front (hence the use of new_inode()), but could just as well add to sb list
> afterwards.

> ---
> diff --git a/fs/inode.c b/fs/inode.c
> index 0df41bb77e0f..03c0d7c1296f 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1098,8 +1098,10 @@ struct inode *iget5_locked(struct super_block *sb, unsigned long hashval,
>  
>  		if (new) {
>  			inode = inode_insert5(new, hashval, test, set, data);
> -			if (unlikely(inode != new))
> -				iput(new);
> +			if (unlikely(inode != new)) {
> +				inode_sb_list_del(inode);
> +				destroy_inode(new);
> +			}

The thing is, until you put it into the list, it's invisible to everyone other
than iget5_locked() - no references in any shared data structures.  Which
outweighs the "it's somewhat irregular in not being on the list" considerably,
as far as the complexity of analysis goes, especially since there are inodes
that never get on that list and it's not something exotic - all sockets and
pipes are that way, for starters.  So IMO that should be dealt with in
inode_insert5().
