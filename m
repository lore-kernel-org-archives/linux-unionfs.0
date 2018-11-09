From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v8 2/2] overlayfs: override_creds=off option bypass
 creator_cred
Date: Fri, 9 Nov 2018 10:20:41 -0500
Message-ID: <20181109152041.GC28565@redhat.com>
References: <20181106230117.127616-1-salyzyn@android.com>
 <20181106230117.127616-2-salyzyn@android.com>
 <20181108200106.GB3663@redhat.com>
 <b057da99-adc6-b355-fb57-b314a29f298f@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b057da99-adc6-b355-fb57-b314a29f298f@android.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salyzyn <salyzyn@android.com>
Cc: linux-kernel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, "Eric W . Biederman" <ebiederm@xmission.com>, Amir Goldstein <amir73il@gmail.com>, Randy Dunlap <rdunlap@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>, linux-unionfs@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@android.com
List-Id: linux-unionfs@vger.kernel.org

On Thu, Nov 08, 2018 at 01:28:32PM -0800, Mark Salyzyn wrote:
> On 11/08/2018 12:01 PM, Vivek Goyal wrote:
> > On Tue, Nov 06, 2018 at 03:01:15PM -0800, Mark Salyzyn wrote:
> > > By default, all access to the upper, lower and work directories is the
> > > recorded mounter's MAC and DAC credentials.  The incoming accesses are
> > > checked against the caller's credentials.
> > Ok, I am trying to think of scenarios where override_creds=off can
> > provide any privilege escalation. How about following.
> > 
> > $ mkdir lower lower/foo upper upper/foo work merged
> > $ touch lower/foo/bar.txt
> > $ chmod 700 lower/foo/
> > 
> > # Mount overlay with override_creds=off
> > 
> > $ mount -t overlay -o
> > lowerdir=lower,upperdir=upper,workdir=work,override_creds=off none merged
> > 
> > # Try to read lower/foo as unpriviliged user. Say "test"
> > # su test
> > # ls merged/foo/
> > ls: cannot access 'merged/foo/': Operation not permitted
> > 
> > # Now first try to do same operation as root and retry as test user.
> > $ exit
> > $ ls merged/foo
> > bar.txt
> > $ su test
> > $ ls merged/foo
> > bar.txt
> > 
> > lower/foo/ is not readable by user "test". So it fails in first try. Later
> > "root" accesses it and it populates cache in overlayfs. When test retries,
> > it gets these entries from cache.
> > 
> > With override_creds=on this is not a problem because overlay provides
> > this as functionality as long as mounter as access to lower/foo/.
> > 
> > But with override_creds=off, mounter is not providing any such
> > functionality and we are exposing an issue where cache will make
> > something available which is not normally available.
> > 
> > I think it probably is a good idea to do something about it?
> > 
> > Thanks
> > Vivek
> > 
> Good stuff.
> 
> That sounds like a bug in cache (!) to not recheck caller's credentials.
> Currently unsure how/where to force bypass of the cache (performance hit) as
> it is wired in throughout the code without a clear off switch, or rechecking
> of the credentials at access. This does need to be addressed to make this
> 'feature' more useful/trusted for non-MAC controlled, use cases.

DAC is just an example. There is no reason same issue will not happen
with MAC? Proacess A with correct MAC priviliges will fill overlay
cache and process B without correct MAC priviliges will still be able
to get information about dentry.

As Amir suggested, for now documenting this probably is fine. I can't
think of any other good options either. May be Miklos has some ideas here.

Thanks
Vivek
