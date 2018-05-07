Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180507174102.24086-17-vgoyal@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com> <20180507174102.24086-17-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 7 May 2018 21:18:11 +0300
Message-ID: <CAOQ4uxhLoFqXYMzsxh41cZr0t7NcDHrgRKT2FAZj+z2rUorJHg@mail.gmail.com>
Subject: Re: [PATCH v15 16/30] ovl: Add helper ovl_inode_real_data()
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, May 7, 2018 at 8:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Add an helper to retrieve real data inode associated with overlay inode.
> This helper will ignore all metacopy inodes and will return only the
> real inode which has data.
>

Title of the patch uses the old helper name.

Thanks,
Amir.
