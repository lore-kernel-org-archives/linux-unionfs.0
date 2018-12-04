From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: overlayfs access checks on underlying layers
Date: Tue, 4 Dec 2018 11:15:06 -0500
Message-ID: <20181204161506.GB16818@redhat.com>
References: <26bce3be-49c2-cdd8-af03-1a78d0f268ae@tycho.nsa.gov>
 <CAJfpeguL9xOh9Eq8LOP=ddJ4YD6nbp2UY6e2AYDVoHeCLuVhZA@mail.gmail.com>
 <6b125e8e-413f-f8e6-c7ae-50f7235c8960@tycho.nsa.gov>
 <CAJfpegv6y56k1-Tewu-Pu3x1W75LL6qYB6Hb6=n+2BJoNfEigA@mail.gmail.com>
 <c993dba4-5129-7f04-2724-a82a1f1cafa3@tycho.nsa.gov>
 <f84bbe0b-f4c1-50e0-8c84-a6589154b3ae@tycho.nsa.gov>
 <CAJfpegtBDTMbmKd6eDxRmtSJjGN6CnpGK_QPNSsxjkOoeu=1pQ@mail.gmail.com>
 <4c20a261-5ce1-f0a2-8d40-c6032a023216@tycho.nsa.gov>
 <20181204151549.GA21509@redhat.com>
 <311721a0-26d4-3cf6-1628-acb2c2b1478b@tycho.nsa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <311721a0-26d4-3cf6-1628-acb2c2b1478b@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Ondrej Mosnacek <omosnace@redhat.com>, "J. Bruce Fields" <bfields@fieldses.org>, Mark Salyzyn <salyzyn@android.com>, Paul Moore <paul@paul-moore.com>, linux-kernel@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org, Daniel J Walsh <dwalsh@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Dec 04, 2018 at 10:42:35AM -0500, Stephen Smalley wrote:

[..]
> > > Yes, in that case there isn't an escalation of privilege for the mounter (I
> > > acknowledged that above).  I'm still not sure copy-up of special files is a
> > > good idea though:
> > > 
> > > - In the case of device files, there is the potential for mischief by the
> > > client task in misusing the mounter's privileges to gain access to otherwise
> > > unusable device node (nodev lower vs upper?),
> > 
> > I was thinking about it as well. But client can always bypass permissions
> > of lower device inode by first removing device file and then by doing
> > a mknod. And that will be equivalent of copy up. IOW, IIUC, we do not deny
> > mknod to client and that always creates a way for it to write to device
> > file (and it does not matter what are permissions on lower?)
> 
> I'm not sure what you mean by "we do not deny mknod to client".  Depends on
> your policy and what context the client is running in.  Plenty of situations
> where the client is not allowed to create device files directly, and the
> mounter is.
> 

Oh, I meant for the cases where policy allows client to mknod with context
label. In that case, it does not matter what's the label on lower. Client
can always bypass it by first removing device node and creating a new
device node.

Thanks
Vivek
