From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 3/7] security,overlayfs: Provide security hook for copy
 up of xattrs for overlay file
Date: Tue, 12 Jul 2016 10:02:03 +1000
Message-ID: <20160712100203.0c644871@canb.auug.org.au>
References: <1467994782-26474-4-git-send-email-vgoyal@redhat.com>
	<201607090113.z0EuiSaT%fengguang.wu@intel.com>
	<20160711134004.GA7728@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160711134004.GA7728@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org, miklos@szeredi.hu, sds@tycho.nsa.gov, pmoore@redhat.com, casey@schaufler-ca.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org, dwalsh@redhat.com, dhowells@redhat.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi Vivek,

On Mon, 11 Jul 2016 09:40:04 -0400 Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Sat, Jul 09, 2016 at 01:41:38AM +0800, kbuild test robot wrote:
> > Hi,
> > 
> > [auto build test ERROR on next-20160708]
> > [also build test ERROR on v4.7-rc6]
> > [cannot apply to pcmoore-selinux/next security/next v4.7-rc6 v4.7-rc5 v4.7-rc4]
> > [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]  
> 
> These patches should be applied on top of overlayfs-next branch of
> miklos's vfs tree.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next

That is included in linux-next ...

-- 
Cheers,
Stephen Rothwell
