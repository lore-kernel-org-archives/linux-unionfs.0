From: Mark Fasheh <mfasheh@suse.de>
Subject: Re: [PATCH 1/4] vfs: introduce function to map unique ino/dev pairs
Date: Wed, 1 Aug 2018 15:59:31 +0000
Message-ID: <20180801155931.GC20761@wotan.suse.de>
References: <20180731211045.5671-1-mfasheh@suse.de>
 <20180731211045.5671-2-mfasheh@suse.de>
 <20180731232127.GB20761@wotan.suse.de>
 <CAOQ4uxiXV=jobVxp_T2NNb7TdbDX+qNjfm4VCr5qAjgLX9BrgA@mail.gmail.com>
Reply-To: Mark Fasheh <mfasheh@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiXV=jobVxp_T2NNb7TdbDX+qNjfm4VCr5qAjgLX9BrgA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, overlayfs <linux-unionfs@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

Hi Amir,

On Wed, Aug 01, 2018 at 08:41:14AM +0300, Amir Goldstein wrote:
> > +void vfs_map_unique_ino_dev(struct dentry *dentry, u64 *ino, dev_t *dev)
> 
> I find this function name a bit more than function can guaranty.
> It's just a fancy wrapper around ->getattr()
> How about vfs_get_ino_dev() ?

Yeah I agree with that. An early version actually had the name
vfs_get_ino_dev(), I don't mind going back to it.

Thanks for the review!
	--Mark
