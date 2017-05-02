From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] xfs: publish UUID in struct super_block
Date: Tue, 2 May 2017 16:17:51 +0200
Message-ID: <20170502141751.GA21564@lst.de>
References: <1493388001-15879-1-git-send-email-amir73il@gmail.com> <20170502073019.GD11582@lst.de> <CAOQ4uxjKbgCwhV4iBNVyfmS5+iR3o1BPF+PDj7YmrPP-qTv1eA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjKbgCwhV4iBNVyfmS5+iR3o1BPF+PDj7YmrPP-qTv1eA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J . Wong" <darrick.wong@oracle.com>, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs <linux-xfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, May 02, 2017 at 05:13:56PM +0300, Amir Goldstein wrote:
> How can it create problems if uniqueness is not guaranteed with
> Current s_uuid? Even if we did make the xfs uuid table code generic
> It couldn't be the vfs default. Filesystems will have to opt in.

It creates problems if you e.g. mount an ext4 fs and a dm snaphot of
it.  The non-XFS file systems are simply buggy in this regard.

Non-uniqueue uuids are an absolute no-go.
