From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v7] ovl: Improving syncfs efficiency
Date: Fri, 26 Jan 2018 17:08:28 +0100
Message-ID: <20180126160828.ytgyyml2lxztsehg@quack2.suse.cz>
References: <1516872955-10069-1-git-send-email-cgxu519@icloud.com>
 <20180125143250.7vulbi2ytxmgk7fu@quack2.suse.cz>
 <35D4AADF-5812-4F73-AF09-49E732B5F4A3@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36540 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752061AbeA0Jqc (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 27 Jan 2018 04:46:32 -0500
Content-Disposition: inline
In-Reply-To: <35D4AADF-5812-4F73-AF09-49E732B5F4A3@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Jan Kara <jack@suse.cz>, miklos@szeredi.hu, amir73il@gmail.com, linux-unionfs@vger.kernel.org

Hi Chengguang!

On Fri 26-01-18 11:02:03, Chengguang Xu wrote:
> > AFAIU your code OVL_EVICT_PENDING should be always set when this function
> > is called. Maybe just make a WARN_ON from this condition?
> 
> OK, I’ll add.
> 
> > 
> >> +		wqh = bit_waitqueue(&oi->flags, OVL_EVICT_PENDING);
> >> +		prepare_to_wait(wqh, &wait.wq_entry, TASK_UNINTERRUPTIBLE);
> >> +		sleep = ovl_test_flag(OVL_EVICT_PENDING, inode);
> 
> I think we also don’t have to check sleep again here because before unlock
> ofs->upper_inodes_lock OVL_EVICT_PENDING will not be cleared. 

I'm not sure what you are suggesting here - i.e., where do you think you are
checking the 'sleep' again?

> >> +		spin_unlock(&inode->i_lock);
> >> +		spin_unlock(&ofs->upper_inodes_lock);
> >> +		if (sleep)
> >> +			schedule();
> >> +		finish_wait(wqh, &wait.wq_entry);
> >> +	}
> >> +}
> >> +
> >> +/**
> >> + * ovl_sync_inodes
> >> + * @sb: The overlayfs super block
> >> + *
> >> + * upper_inodes list is used for organizing ovl inode which has upper inode,
> >> + * by iterating the list to looking for and syncing dirty upper inode.
> >> + *
> >> + * When starting syncing inode, we add the inode to wait list explicitly,
> >> + * in order to save memory we reuse inode->i_wb_list and sb->s_inodes_wb,
> >> + * so those fields have slightly differnt meanings in overlayfs.
> >> + */
> >> +static void ovl_sync_inodes(struct super_block *sb)
> >> +{
> >> +	struct ovl_fs *ofs = sb->s_fs_info;
> >> +	struct ovl_inode *oi;
> >> +	struct inode *inode;
> >> +	struct inode *upper_inode;
> >> +	struct blk_plug plug;
> >> +	LIST_HEAD(sync_tmp_list);
> >> +
> >> +	struct writeback_control wbc_for_sync = {
> >> +		.sync_mode		= WB_SYNC_ALL,
> >> +		.for_sync		= 1,
> >> +		.range_start		= 0,
> >> +		.range_end		= LLONG_MAX,
> >> +		.nr_to_write		= LONG_MAX,
> >> +	};
> >> +
> >> +	blk_start_plug(&plug);
> >> +	spin_lock(&ofs->upper_inodes_lock);
> >> +	list_splice_init(&ofs->upper_inodes, &sync_tmp_list);
> >> +
> >> +	while (!list_empty(&sync_tmp_list)) {
> >> +		oi = list_first_entry(&sync_tmp_list, struct ovl_inode,
> >> +						upper_inodes_list);
> >> +		inode = &oi->vfs_inode;
> >> +		spin_lock(&inode->i_lock);
> >> +
> >> +		list_move_tail(&oi->upper_inodes_list, &ofs->upper_inodes);
> >> +		if (inode->i_state & I_NEW) {
> >> +			spin_unlock(&inode->i_lock);
> >> +			continue;
> >> +		}
> >> +
> >> +		/*
> >> +		 * If ovl inode state is I_FREEING,
> >> +		 * left sync operation to the ovl_evict_inode(),
> >> +		 * so wait here until OVL_EVICT_PENDING flag to be cleared.
> >> +		 */
> >> +		if (inode->i_state & I_FREEING) {
> >> +			ovl_wait_evict_pending(inode);
> > 
> > This is still somewhat racy. The problem is that a wakeup in
> > ovl_wait_evict_pending() can come from all sorts of reasons. You are not
> > guaranteed OVL_EVICT_PENDING is cleared when you are woken up. You cannot
> > easily recheck the flag as the inode *may* really be free by this time.
> 
> I think DEFINE_WAIT_BIT can wakeup sleeping thread only for right reason and
> there is no other place to set OVL_EVICT_PENDING again. IIUC, we don’t have
> to check OVL_EVICT_PENDING in a loop. Am I missing something?

You are correct that wake_up_bit() will only wake up process once it has
cleared the bit. But there can be other wake up sources like signal
delivery so you cannot assume you will get woken only after the inode is
gone...

> > What I'd do to fix this race is not to move inode with OVL_EVICT_PENDING to
> > the tail of ofs->upper_inodes but just keep it in &sync_tmp_list. That way
> > we are sure that either the inode gets freed (thus removed from
> > &sync_tmp_list) and we'll never see it again, or we'll again see it in
> > &sync_tmp_list, see again OVL_EVICT_PENDING, and wait again for it which is
> > what we need.
> 
> If my analysis above is not correct, I’ll modify as your suggestion here.

Please do.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
