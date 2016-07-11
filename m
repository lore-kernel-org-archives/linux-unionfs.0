From: Fengguang Wu <lkp@intel.com>
Subject: Re: [kbuild-all] [PATCH 3/7] security, overlayfs: Provide security
 hook for copy up of xattrs for overlay file
Date: Mon, 11 Jul 2016 21:50:14 +0800
Message-ID: <20160711135014.GA22268@wfg-t540p.sh.intel.com>
References: <1467994782-26474-4-git-send-email-vgoyal@redhat.com>
 <201607090113.z0EuiSaT%fengguang.wu@intel.com>
 <20160711134004.GA7728@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160711134004.GA7728@redhat.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: dhowells@redhat.com, miklos@szeredi.hu, dwalsh@redhat.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, pmoore@redhat.com, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, kbuild-all@01.org, casey@schaufler-ca.com, sds@tycho.nsa.gov, viro@ZenIV.linux.org.uk, Xiaolong Ye <xiaolong.ye@intel.com>
List-Id: linux-unionfs@vger.kernel.org

On Mon, Jul 11, 2016 at 09:40:04AM -0400, Vivek Goyal wrote:
>On Sat, Jul 09, 2016 at 01:41:38AM +0800, kbuild test robot wrote:
>> Hi,
>>
>> [auto build test ERROR on next-20160708]
>> [also build test ERROR on v4.7-rc6]
>> [cannot apply to pcmoore-selinux/next security/next v4.7-rc6 v4.7-rc5 v4.7-rc4]
>> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
>These patches should be applied on top of overlayfs-next branch of
>miklos's vfs tree.
>
>git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next

Good to know that, thank you for the info!

Thanks,
Fengguang
