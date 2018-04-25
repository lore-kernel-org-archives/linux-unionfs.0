From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: [RFC PATCH 00/35] overlayfs: stack file operations
Date: Wed, 25 Apr 2018 23:49:49 +0900
Message-ID: <5342.1524667789@jrobl>
References: <20180412150826.20988-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180412150826.20988-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Miklos Szeredi:
> This patch series reverts the VFS hacks (with the exception of d_path) and

I totally agree with removing d_real things.
It must be good to the world.

If I understand correctly, this series affects file_inode() too.
So there may exist more commits to revert such as
	fea6d2a6 2017-02-14 vfs: Use upper filesystem inode in bprm_fill_uid()

Here is another question.
Does overlayfs support atomic_open?
I remember implementing atomic_open on aufs was rather tricky many years
ago, and I am interested in how overlayfs addresses it.


J. R. Okajima
