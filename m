From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: overlayfs: caller_credentials option bypass creator_cred
Date: Tue, 19 Jun 2018 10:36:17 -0400
Message-ID: <20180619143617.GC22657@redhat.com>
References: <20180618154222.19279-1-salyzyn@android.com>
 <20180618185448.GA8749@redhat.com>
 <f141f883-0dbd-10ea-83b9-a1b38119b0c5@android.com>
 <20180618194345.GA15973@redhat.com>
 <aecdeaca-74cf-54b1-3ea9-4751972074f5@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <aecdeaca-74cf-54b1-3ea9-4751972074f5@android.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salyzyn <salyzyn@android.com>
Cc: linux-kernel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, linux-unionfs@vger.kernel.org, linux-doc@vger.kernel.org, Daniel Walsh <dwalsh@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>
List-Id: linux-unionfs@vger.kernel.org

On Mon, Jun 18, 2018 at 02:59:50PM -0700, Mark Salyzyn wrote:
> On 06/18/2018 12:43 PM, Vivek Goyal wrote:
> > Will it be acceptable to write security policies in such a way so that
> > mounter has access as well.
> Unfortunately No. Policy of minimizing attack surface for a contained root
> service (init in this case). Just because it can mount, does not mean it can
> modify critical content; an attacker could use this to open a hole.
> 
> > Current model does assume that mounter has privileges on underlying files.
> 
> Only ones it appears to need is the workdir AFAIK, had to add ability to
> create in the <wordir> xattr in order to enable r/w mounts later. Although
> not all corners were tested, I did not see any copy_up issues b/c the caller
> had the privs in the Android security model when mounted with this new flag.

So in this system all callers are priviliged and have the capability to
mknod and set trusted xattrs. (Amir mentioned the reason why we switch
creds). If not, then file unlink (Should do mknod), lower non-empty directory
rename (should set trusted REDIRECT) and bunch of other operations should fail.

Thanks
Vivek
