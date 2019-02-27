Return-Path: <eddiehorng.tw@gmail.com>
MIME-Version: 1.0
References: <20190226152739.26408-1-amir73il@gmail.com> <CAJfpegt8sHTJ-CRZhQ+hNj7XWASKa4L0HUDcsyf2vM+BYs0aag@mail.gmail.com>
 <CAOQ4uxgsKbOA3nruProL=yG1rk4XaMrARVSdYja7z7KvY9Eedw@mail.gmail.com>
 <CAJfpegskJEL=5ORX6DcnXTkU39bk85ctV8q9z+xkp1AD7GD=1A@mail.gmail.com>
 <CAOQ4uxgHac1hO-YcquTjoVWdBRc9O64JhqPXBQxHr=1aZNiiHg@mail.gmail.com> <CAJfpegtmcYdTM0OjYyMUjK_nZnLrdE=z02TFe40sZuKCpQcXkA@mail.gmail.com>
In-Reply-To: <CAJfpegtmcYdTM0OjYyMUjK_nZnLrdE=z02TFe40sZuKCpQcXkA@mail.gmail.com>
From: Eddie Horng <eddiehorng.tw@gmail.com>
Date: Wed, 27 Feb 2019 14:49:19 +0800
Message-ID: <CALLuPvq6ctYokpJS5+iJSFsy_epLjSCAtOn=6UepEsW3SXyJ9w@mail.gmail.com>
Subject: Re: [PATCH] ovl: support stacked SEEK_HOLE/SEEK_DATA
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

> > > > OK. What about Eddie's question:
> > > > If realinode is nested overlay inode, then realinode->i_sb->s_maxbytes
> > > > will not reflect the "real" inode's maxbytes.
> > > > Not to mention other crazy things that filesystems may do for SET/CUR/END.
> > > > Take ext4_llseek() for example, for the less common case (ext3 format inode)
> > > > the value of inode->i_sb->s_maxbytes is not used as maxbytes, but a smaller
> > > > value.
> > > >

Hi Amir,
Thanks your detail information and the patch.
I ran into this issue by using a proprietary stacked file system as lower
and the file system does not initial it's s_maxbytes, therefore
caused file larger than 2GB fails lseek. A quick workaround is to set the fs
s_maxbytes to MAX_LFS_FILESIZE, but like you said, for certain cases this might
be a problem.
I have verified this patch with same configuration and the lower inode
f_op->llseek
does get invoked, looks like enough to resolve my particular case.

thanks,
Eddie
