From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] ovl: do not ignore disk quota if current task is not
 privileged
Date: Tue, 10 Jan 2017 11:35:17 -0500
Message-ID: <20170110163517.GE23108@redhat.com>
References: <148404760886.4400.14907571208759802396.stgit@buzz>
 <20170110160647.GD23108@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170110160647.GD23108@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Jan 10, 2017 at 11:06:47AM -0500, Vivek Goyal wrote:
> On Tue, Jan 10, 2017 at 02:26:48PM +0300, Konstantin Khlebnikov wrote:
> > If overlay was mounted by root then quota set for upper layer does not work
> > because overlay now always use mounter's credentials for operations.
> > 
> 
> Hi Konstantin,
> 
> So CAP_SYS_RESOURCE bypasses the quota checks?
> 
> I just created dir upper on xfs filesystem and defined quota of 1G and
> as root user (with cap_sys_resoureces), I am not able to create file
> bigger than 1g in that dir. So looks like xfs quota took affect even
> for privileged user with CAP_SYS_RESOURCE set.
> 
> What am I missing?

As root user, I set limit of 1G on work/ and upper/ dir and created
a file of 4G in lower/ dir and mounted overlay on "merged" dir and
did "touch zerofile", and go error message.

touch: cannot touch 'zerofile': No space left on device

So looks like I am doing something wrong and not be able to reproduce
the issue to begin with.

Vivek
