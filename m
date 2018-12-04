From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: overlayfs access checks on underlying layers
Date: Tue, 4 Dec 2018 10:42:43 -0500
Message-ID: <20181204154243.GA16818@redhat.com>
References: <CAJfpeguL9xOh9Eq8LOP=ddJ4YD6nbp2UY6e2AYDVoHeCLuVhZA@mail.gmail.com>
 <6b125e8e-413f-f8e6-c7ae-50f7235c8960@tycho.nsa.gov>
 <CAJfpegv6y56k1-Tewu-Pu3x1W75LL6qYB6Hb6=n+2BJoNfEigA@mail.gmail.com>
 <c993dba4-5129-7f04-2724-a82a1f1cafa3@tycho.nsa.gov>
 <f84bbe0b-f4c1-50e0-8c84-a6589154b3ae@tycho.nsa.gov>
 <CAJfpegtBDTMbmKd6eDxRmtSJjGN6CnpGK_QPNSsxjkOoeu=1pQ@mail.gmail.com>
 <4c20a261-5ce1-f0a2-8d40-c6032a023216@tycho.nsa.gov>
 <20181204151549.GA21509@redhat.com>
 <20181204152248.GB21509@redhat.com>
 <CAJfpegtFVvq286HAorGLg6ywMsfs51KqaQwFkcuV7Dtu8TLaLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJfpegtFVvq286HAorGLg6ywMsfs51KqaQwFkcuV7Dtu8TLaLg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Ondrej Mosnacek <omosnace@redhat.com>, "J. Bruce Fields" <bfields@fieldses.org>, Mark Salyzyn <salyzyn@android.com>, Paul Moore <paul@paul-moore.com>, linux-kernel@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org, Daniel J Walsh <dwalsh@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Dec 04, 2018 at 04:31:09PM +0100, Miklos Szeredi wrote:
> On Tue, Dec 4, 2018 at 4:22 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > Having said that, this still create little anomaly when mknod to client
> > is not allowed on context label. So a device file, which is on lower
> > and client can not open it for read/write on host, it can now be opened
> > for read/write because mounter will allow access. So why it is different
> > that regular copy up. Well, in regular copy up, we created a copy of
> > the original object and allowed writing to that object (cp --preserve=all)
> > model. But in case of device file, writes will go to same original
> > object. (And not a separate copy).
> 
> That's true.
> 
> In that sense copy up of special file should result in upper having
> the same label as of lower, right?

I guess that might be reasonable (if this behavior is a concern). So even
after copy up, client will not be able to read/write a device if it was
not allowed on lower. 

Stephen, what do you think about retaining label of lower for device
files during copy up. What about socket/fifo.

Thanks
Vivek
