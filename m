Return-Path: <tytso@thunk.org>
Date: Mon, 29 Oct 2018 18:04:04 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: overlayfs 4.19: unable to make backup link: Invalid cross-device
 link
Message-ID: <20181029220404.GB15839@thunk.org>
References: <20181027200450.GA5909@thunk.org>
 <CAJfpegtCYkXiSYtw4dWGc=Fj2U3GaWiOiub+JmZ8pRXHNk4ERQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegtCYkXiSYtw4dWGc=Fj2U3GaWiOiub+JmZ8pRXHNk4ERQ@mail.gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Oct 29, 2018 at 09:31:58AM +0100, Miklos Szeredi wrote:
> Can you please post
> 
>   grep OVERLAY_FS .config

Sure, here you go:

% zgrep OVERLAY_FS /proc/config.gz
CONFIG_OVERLAY_FS=m
CONFIG_OVERLAY_FS_REDIRECT_DIR=y
CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW=y                                        
CONFIG_OVERLAY_FS_INDEX=y
# CONFIG_OVERLAY_FS_XINO_AUTO is not set
CONFIG_OVERLAY_FS_METACOPY=y

And this was the config on the working 4.18 kernel:

% grep OVERLAY_FS /boot/config-4.18.0-2-amd64 
CONFIG_OVERLAY_FS=m
# CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW=y
# CONFIG_OVERLAY_FS_INDEX is not set
# CONFIG_OVERLAY_FS_XINO_AUTO is not set

The underlying file system is ext4.

Thanks!

					- Ted
