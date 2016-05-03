From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [RFC 0/8] Xattr inode operation removal
Date: Tue, 03 May 2016 09:12:49 -0400
Message-ID: <1462281169.2836.13.camel@linux.vnet.ibm.com>
References: <1462229118-13123-1-git-send-email-agruenba@redhat.com>
	 <1462243235.2559.23.camel@linux.vnet.ibm.com>
	 <CAHc6FU4DNkm09qdmdxppFLJnKF9M5bSxhibByNXPpKRhYA1Z4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <ecryptfs-owner@vger.kernel.org>
In-Reply-To: <CAHc6FU4DNkm09qdmdxppFLJnKF9M5bSxhibByNXPpKRhYA1Z4A@mail.gmail.com>
Sender: ecryptfs-owner@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-ima-devel@lists.sourceforge.net, LSM <linux-security-module@vger.kernel.org>, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: linux-unionfs@vger.kernel.org

On Tue, 2016-05-03 at 13:49 +0200, Andreas Gruenbacher wrote:
> On Tue, May 3, 2016 at 4:40 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > Hi Andreas,
> >
> > On Tue, 2016-05-03 at 00:45 +0200, Andreas Gruenbacher wrote:
> >> Hi all,
> >>
> >> what are your thoughts on this patch set?  It applies on top of the
> >> work.xattr branch [*], converts the remaining filesystems over to xattr
> >> handlers, and replaces the getxattr, setxattr, and removexattr inode
> >> operations.  The only way to implement getxattr, setxattr, and
> >> removexattr with this approach is through xattr handlers.
> >
> > The patch description should provide the motivation/reason for the
> > change (eg. performance, locking).  Up to now these xattr functions
> > required the caller to take the i_mutex.  Is the i_mutex still required?
> 
> Yes, the documentation needs updating. The locking rules are still the same.

I meant to say, this cover letter needs to provide the motivation/reason
for the change(s).   From my perspective, the main motivation would
either be "locking" or keeping the file data and metadata in sync.  If
these aren't the motivation/reasons for the change, please provide an
explanation.

thanks,

Mimi
