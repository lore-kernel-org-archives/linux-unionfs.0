From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2] overlay/030: test immutable and append-only upper
 files
Date: Thu, 6 Apr 2017 11:45:57 +0800
Message-ID: <20170406034557.GG22845@eguan.usersys.redhat.com>
References: <1491389271-24726-2-git-send-email-amir73il@gmail.com>
 <1491394167-31409-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1491394167-31409-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Wed, Apr 05, 2017 at 03:09:27PM +0300, Amir Goldstein wrote:
> Run the t_immutable test program for immutable/append-only files
> and directories in an overlayfs upper directory.
> 
> This test is similar and was derived from generic/079, but
> the original test is _notrun on overlay mount because FS_IOC_GETFLAGS
> FS_IOC_SETFLAGS ioctls fail on overlay directory inodes.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  tests/generic/079     |  6 ++---
>  tests/overlay/030     | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/030.out |  5 ++++
>  tests/overlay/group   |  1 +
>  4 files changed, 81 insertions(+), 4 deletions(-)
>  create mode 100755 tests/overlay/030
>  create mode 100644 tests/overlay/030.out
> 
> Eryu,
> 
> Here is v2 with fixes to your comments.
> 
> I also changed generic/079 to use modern _require_* statements.
> and removed _scratch_unmount from its cleanup callback.

Thanks! But it'd be better to have two patches, one for new case and one
for 079 cleanup.

Thanks,
Eryu
