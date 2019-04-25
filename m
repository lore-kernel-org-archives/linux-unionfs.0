Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23050 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbfDYAz7 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 24 Apr 2019 20:55:59 -0400
Date: Thu, 25 Apr 2019 08:55:47 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v2] ovl: do not generate duplicate fsnotify events for
 "fake" path
Message-ID: <201904250818.zze6O4qk%lkp@intel.com>
References: <20190424163950.14123-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190424163950.14123-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: kbuild-all@01.org, Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>, Murphy Zhou <jencce.kernel@gmail.com>, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Hi Amir,

I love your patch! Perhaps something to improve:

[auto build test WARNING on miklos-vfs/overlayfs-next]
[also build test WARNING on v5.1-rc6 next-20190424]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Amir-Goldstein/ovl-do-not-generate-duplicate-fsnotify-events-for-fake-path/20190425-030408
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

sparse warnings: (new ones prefixed by >>)

>> fs/overlayfs/file.c:32:49: sparse: sparse: restricted fmode_t degrades to integer
   fs/overlayfs/file.c:54:30: sparse: sparse: restricted fmode_t degrades to integer

vim +32 fs/overlayfs/file.c

    25	
    26	static struct file *ovl_open_realfile(const struct file *file,
    27					      struct inode *realinode)
    28	{
    29		struct inode *inode = file_inode(file);
    30		struct file *realfile;
    31		const struct cred *old_cred;
  > 32		int flags = file->f_flags | O_NOATIME | FMODE_NONOTIFY;
    33	
    34		old_cred = ovl_override_creds(inode->i_sb);
    35		realfile = open_with_fake_path(&file->f_path, flags, realinode,
    36					       current_cred());
    37		revert_creds(old_cred);
    38	
    39		pr_debug("open(%p[%pD2/%c], 0%o) -> (%p, 0%o)\n",
    40			 file, file, ovl_whatisit(inode, realinode), file->f_flags,
    41			 realfile, IS_ERR(realfile) ? 0 : realfile->f_flags);
    42	
    43		return realfile;
    44	}
    45	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
