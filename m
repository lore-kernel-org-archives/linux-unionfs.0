From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v8 2/2] overlayfs: override_creds=off option bypass creator_cred
Date: Fri, 9 Nov 2018 05:05:17 +0200
Message-ID: <CAOQ4uxjVPKSaJ2oscvM7jtsDVabnq_qMPg7k4KQEyOLAVPojcg@mail.gmail.com>
References: <20181106230117.127616-1-salyzyn@android.com> <20181106230117.127616-2-salyzyn@android.com>
 <20181108200106.GB3663@redhat.com> <b057da99-adc6-b355-fb57-b314a29f298f@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b057da99-adc6-b355-fb57-b314a29f298f@android.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salyzyn <salyzyn@android.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, "Eric W. Biederman" <ebiederm@xmission.com>, Randy Dunlap <rdunlap@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>, overlayfs <linux-unionfs@vger.kernel.org>, linux-doc@vger.kernel.org, kernel-team@android.com
List-Id: linux-unionfs@vger.kernel.org

On Thu, Nov 8, 2018 at 11:28 PM Mark Salyzyn <salyzyn@android.com> wrote:
>
> On 11/08/2018 12:01 PM, Vivek Goyal wrote:
>
> On Tue, Nov 06, 2018 at 03:01:15PM -0800, Mark Salyzyn wrote:
>
> By default, all access to the upper, lower and work directories is the
> recorded mounter's MAC and DAC credentials.  The incoming accesses are
> checked against the caller's credentials.
>
> Ok, I am trying to think of scenarios where override_creds=3Doff can
> provide any privilege escalation. How about following.
>
> $ mkdir lower lower/foo upper upper/foo work merged
> $ touch lower/foo/bar.txt
> $ chmod 700 lower/foo/
>
> # Mount overlay with override_creds=3Doff
>
> $ mount -t overlay -o
> lowerdir=3Dlower,upperdir=3Dupper,workdir=3Dwork,override_creds=3Doff non=
e merged
>
> # Try to read lower/foo as unpriviliged user. Say "test"
> # su test
> # ls merged/foo/
> ls: cannot access 'merged/foo/': Operation not permitted
>
> # Now first try to do same operation as root and retry as test user.
> $ exit
> $ ls merged/foo
> bar.txt
> $ su test
> $ ls merged/foo
> bar.txt
>
> lower/foo/ is not readable by user "test". So it fails in first try. Late=
r
> "root" accesses it and it populates cache in overlayfs. When test retries=
,
> it gets these entries from cache.
>
> With override_creds=3Don this is not a problem because overlay provides
> this as functionality as long as mounter as access to lower/foo/.
>
> But with override_creds=3Doff, mounter is not providing any such
> functionality and we are exposing an issue where cache will make
> something available which is not normally available.
>
> I think it probably is a good idea to do something about it?
>
> Thanks
> Vivek
>
> Good stuff.
>
> That sounds like a bug in cache (!) to not recheck caller's credentials. =
Currently unsure how/where to force bypass of the cache (performance hit) a=
s it is wired in throughout the code without a clear off switch, or recheck=
ing of the credentials at access. This does need to be addressed to make th=
is 'feature' more useful/trusted for non-MAC controlled, use cases.
>
> This is not a problem in the Android usage case since DAC is simple and a=
ll can be read, execute bits might be controlled, the owners and perms are =
otherwise unremarkable in the affected arenas that are utilizing overlayfs.=
 Not using it for a generic r/w backing except in rooted debug scenarios by=
 developers, otherwise everything is r/o, MAC on the other hand is complex =
and heavily inspected. We do, however, want multi level security in that bo=
th DAC and MAC can be trusted and can protect each other from holes.
>
> Sounds like the caveats in the documentation need to be expanded if _no_ =
solution for this kind of access pattern becomes apparent.
>

I think maybe you could append the "behavior of the overlay is undefined" c=
lause
to the caveats to cover issues like the one raised by Vivek.

Mark,

I have some Android internals background, so I have a general
understanding of the
use case, but I can understand why people have a hard time connecting to th=
e
motivation, thinking "their security model must be flawed".

I am not sure if you are avoiding laying out the details of the model
because you
are not allowed to expose details or because you feel details may confuse u=
s.
If the latter, then I think that actually listing the details of the
overlays used in Android
and some concrete examples of access policies to those overlays could
benefit the
discussion on the feature.
To clarify, this only a suggestion. I have no objection to the patch.

Thanks,
Amir.
