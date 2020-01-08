Return-Path: <tycho@tycho.ws>
Return-Path: <tycho@tycho.ws>
Date: Wed, 8 Jan 2020 08:29:56 -0700
From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: OverlaysFS offline tools
Message-ID: <20200108152956.GD1169@cisco>
References: <CAOQ4uxjFC81hikgg0WaF0Z3Mxkk3iDakKx2Ttuhp_L_2Tnc6xQ@mail.gmail.com>
 <20200108140611.GA1995@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200108140611.GA1995@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Amir Goldstein <amir73il@gmail.com>, StuartIanNaylor <rolyantrauts@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, Linux Containers <containers@lists.linux-foundation.org>, "zhangyi (F)" <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>, kmxz <kxzkxz7139@gmail.com>, James.Bottomley@HansenPartnership.com
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Jan 08, 2020 at 09:06:11AM -0500, Vivek Goyal wrote:
> - shiftfs
> 
>   As of now they are relying on doing chown of the image but will really
>   like to see the ability to shift uid/gids using shiftfs or using
>   VFS layer solution.

I think James is working on this:

https://lore.kernel.org/linux-fsdevel/20200104203946.27914-1-James.Bottomley@HansenPartnership.com/

Tycho
