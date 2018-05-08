Return-Path: <vgoyal@redhat.com>
Date: Tue, 8 May 2018 09:42:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v15 00/30] overlayfs: Delayed copy up of data
Message-ID: <20180508134230.GC3501@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180507174102.24086-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, May 07, 2018 at 01:40:32PM -0400, Vivek Goyal wrote:
> Hi,
> 
> This is V15 of overlayfs metadata only copy-up feature. These patches I
> have rebased on top of Miklos overlayfs-next tree's branch overlayfs-rorw.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-rorw
> 
> Patches are also available here.
> 
> https://github.com/rhvgoyal/linux/commits/metacopy-v15
> 
> I have run unionmount-testsuite and "./check -overlay -g quick" and that
> works. Only 4 overlay tests fail, which fail on vanilla kernel too.
> 

Hi Amir,

I have taken care of your review comments and pushed new patches at
"metcopy-next" branch.

https://github.com/rhvgoyal/linux/commits/metacopy-next

Changes are small and I am not sure if I should be patch bomb mailing
list again.

Amir, Miklos, do let me know if I should post V16 patches on mailing
list.

Thanks
Vivek
