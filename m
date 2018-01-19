From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5] ovl: Improving syncfs efficiency
Date: Fri, 19 Jan 2018 09:36:57 +0100
Message-ID: <20180119083657.od2jfdnbc2bf7bin@quack2.suse.cz>
References: <1516258412-122012-1-git-send-email-cgxu519@icloud.com>
 <20180118120551.y4hsjfdscwfkwxsb@quack2.suse.cz>
 <96114D99-8050-41B5-85E5-A3BCF3DDCDE9@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36080 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754693AbeASIg6 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 19 Jan 2018 03:36:58 -0500
Content-Disposition: inline
In-Reply-To: <96114D99-8050-41B5-85E5-A3BCF3DDCDE9@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Jan Kara <jack@suse.cz>, miklos@szeredi.hu, amir73il@gmail.com, linux-unionfs@vger.kernel.org

On Fri 19-01-18 10:19:55, Chengguang Xu wrote:
> >> +				iput_inode = inode;
> >> +				goto next;
> >> +			}
> >> +		} else {
> >> +			sync_inode(upper_inode, &wbc_for_sync);
> >> +		}
> >> +
> >> +		/*
> >> +		 * When ovl inode is not in sb->s_inodes_wb list,
> >> +		 * hold referece until finishing waiting on the inode.
> >> +		 */
> >> +		spin_lock(&sb->s_inode_wblist_lock);
> >> +		if (list_empty(&inode->i_wb_list)) {
> >> +			list_add_tail(&inode->i_wb_list, &sb->s_inodes_wb);
> >> +			iput_inode = NULL;
> >> +		} else {
> >> +			iput_inode = inode;
> >> +		}
> >> +		spin_unlock(&sb->s_inode_wblist_lock);
> >> +
> >> +next:
> >> +		if (need_resched()) {
> >> +			blk_finish_plug(&plug);
> >> +			cond_resched();
> >> +			blk_start_plug(&plug);
> >> +		}
> >> +		spin_lock(&ofs->upper_inodes_lock);
> >> +	}
> >> +	spin_unlock(&ofs->upper_inodes_lock);
> >> +	blk_finish_plug(&plug);
> >> +
> >> +	if (iput_inode)
> >> +		iput(iput_inode);
> >> +}
> >> +
> >> +static void ovl_wait_inodes(struct super_block *sb)
> >> +{
> >> +	LIST_HEAD(sync_list);
> >> +	struct inode *inode;
> >> +	struct inode *upper_inode;
> >> +
> >> +	/*
> >> +	 * ovl inode in sb->s_inodes_wb list has already got inode reference,
> >> +	 * this will avoid silent droping during waiting on it.
> >> +	 * Splice the sync wait list onto a temporary list to avoid waiting on
> >> +	 * inodes that have started writeback after this point.
> >> +	 */
> >> +	mutex_lock(&sb->s_sync_lock);
> >> +	spin_lock(&sb->s_inode_wblist_lock);
> >> +	list_splice_init(&sb->s_inodes_wb, &sync_list);
> >> +	spin_unlock(&sb->s_inode_wblist_lock);
> >> +
> >> +	while (!list_empty(&sync_list)) {
> >> +		inode = list_first_entry(&sync_list, struct inode, i_wb_list);
> >> +		list_del_init(&inode->i_wb_list);
> > 
> > I think this is racy. ovl_sync_inodes() can be looking at and manipulating
> > ->i_wb_list while ovl_wait_inodes() works with it. So I think you need to
> > hold sb->s_inode_wblist_lock until you remove inode from the i_wb_list.
> 
> There is a condition to check whether inode->i_wb_list is empty or not 
> before ovl_sync_inodes() manipulates ->i_wb_list. 
> I think this check can avoid race, am i missing something?

Firstly, it is not *obvious* it won't race in a bad way and as such it
should have a comment explaining this and a very good reason why you are
adding code correctness is not obvious.

Secondly, I really think there's a race if the CPU aggressively reorders
stuff. For example:

CPU0				CPU1

list_del_init()
  RAX = entry->prev
  RBX = entry->next
  entry->next = entry
				list_empty()
				  list_add_tail(entry, head)
				    entry->next = head->next
				    entry->prev = head
  RAX->next = RBX
  PBX->prev = RAX
  entry->prev = entry
    - we have just corrupted the list

A rule of thumb is that you cannot work with a list in a lockless manner
unless you are sure nobody can be manipulating with the entries...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
