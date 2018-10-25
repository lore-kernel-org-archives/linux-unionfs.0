Return-Path: <lkp@intel.com>
Date: Thu, 25 Oct 2018 09:31:00 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v2 10/13] NFS inter ssc open
Message-ID: <201810250954.PciQTirJ%fengguang.wu@intel.com>
References: <20181024195837.35532-12-olga.kornievskaia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181024195837.35532-12-olga.kornievskaia@gmail.com>
To: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Cc: kbuild-all@01.org, trond.myklebust@hammerspace.com, anna.schumaker@netapp.com, viro@zeniv.linux.org.uk, smfrench@gmail.com, miklos@szeredi.hu, linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Hi Olga,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on nfs/linux-next]
[also build test WARNING on v4.19]
[cannot apply to next-20181019]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Olga-Kornievskaia/client-side-support-for-inter-SSC-copy/20181025-043859
base:   git://git.linux-nfs.org/projects/trondmy/linux-nfs.git linux-next


coccinelle warnings: (new ones prefixed by >>)

>> fs/nfs/nfs4file.c:345:12-18: WARNING: PTR_ERR_OR_ZERO can be used

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
