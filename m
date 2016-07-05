From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 3/5] selinux: Pass security pointer to
 determine_inode_label()
Date: Tue, 5 Jul 2016 17:09:21 -0400
Message-ID: <20160705210921.GF17987@redhat.com>
References: <1467733854-6314-1-git-send-email-vgoyal@redhat.com>
 <1467733854-6314-4-git-send-email-vgoyal@redhat.com>
 <7669deeb-12db-deeb-abd2-1743acf3721b@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7669deeb-12db-deeb-abd2-1743acf3721b@schaufler-ca.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: miklos@szeredi.hu, sds@tycho.nsa.gov, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org, dwalsh@redhat.com, dhowells@redhat.com, pmoore@redhat.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, Jul 05, 2016 at 01:25:22PM -0700, Casey Schaufler wrote:
> On 7/5/2016 8:50 AM, Vivek Goyal wrote:
> > Right now selinux_determine_inode_label() works on security pointer of
> > current task. Soon I need this to work on a security pointer retrieved
> > from a set of creds. So start passing in a pointer and caller can decide
> > where to fetch security pointer from.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  security/selinux/hooks.c | 17 +++++++++--------
> >  1 file changed, 9 insertions(+), 8 deletions(-)
> >
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index c68223c..86a07ed 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -1785,13 +1785,13 @@ out:
> >  /*
> >   * Determine the label for an inode that might be unioned.
> >   */
> > -static int selinux_determine_inode_label(struct inode *dir,
> > -					 const struct qstr *name,
> > -					 u16 tclass,
> > +static int selinux_determine_inode_label(const void *security,
> 
> You know the type. Why not use it?
> 
> 	static int selinux_determine_inode_label(const struct task_security_struct *tsec,

Will change it. All callers use current_security() to fetch this pointer
and it returns void * and I guess I assumed that compiler will complain
but it does not seem to complain. 

Vivek
