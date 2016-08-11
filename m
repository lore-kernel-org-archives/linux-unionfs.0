From: Daniel J Walsh <dwalsh@redhat.com>
Subject: Re: [RFC PATCH 0/9][V3] Overlayfs SELinux Support
Date: Thu, 11 Aug 2016 08:39:32 -0400
Message-ID: <40ce13d0-e116-2edf-c383-80aaec2d2412@redhat.com>
References: <1468421095-22322-1-git-send-email-vgoyal@redhat.com>
 <CAHC9VhR7YM+VPXVO=no3bDsj4w5HZz1DiJZR5XajCEfMSYF6=g@mail.gmail.com>
 <CAHC9VhSPj61__P=esyYHhEfQyGKBLZjcoPi1QBFbeRdA2qdNeA@mail.gmail.com>
 <CAJfpegsLh1=NKiPaPEK0=7pGOv_rVXGDxVJU+TcO_tjBhYhK1Q@mail.gmail.com>
 <CAHC9VhR=uX-h+gavdWbntojzKr4wF6LUfnHr9z1pOjT69H=uRA@mail.gmail.com>
 <0dcbfc0b-11bd-061e-f679-91346ddc5ac1@redhat.com>
 <CAHC9VhTpq=KCKYs-QUw61=DX5Rqq1Gc2gYA_FYQdrqgHHUrnYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbcHKMje (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 11 Aug 2016 08:39:34 -0400
In-Reply-To: <CAHC9VhTpq=KCKYs-QUw61=DX5Rqq1Gc2gYA_FYQdrqgHHUrnYA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>
Cc: Paul Moore <pmoore@redhat.com>, James Morris <jmorris@namei.org>, Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, LSM <linux-security-module@vger.kernel.org>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org



On 08/11/2016 08:36 AM, Paul Moore wrote:
> On Wed, Aug 10, 2016 at 8:52 AM, Daniel J Walsh <dwalsh@redhat.com> wrote:
>> On 08/10/2016 08:32 AM, Paul Moore wrote:
>>> On Wed, Aug 10, 2016 at 5:11 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>> On Tue, Aug 9, 2016 at 3:19 AM, Paul Moore <paul@paul-moore.com> wrote:
>>>>> Okay, I just merged these patches into selinux#next.  With the
>>>>> exception of some changes to restore the mode argument to
>>>>> ovl_create_or_link() and to fix some whitespace damage the patches
>>>>> were merged cleanly.
>>>> Don't need to add the back the mode argument, just use stat->mode.
>>> Thanks for the pointer (I'm on vacation at the moment and trying to do
>>> this quickly).  Since it was a merge issue, and the branch hasn't been
>>> pulled by Linus, I didn't bother with a new patch, I simply updated
>>> the existing patch from Vivek and re-pushed to selinux#next.  If you
>>> see anything else, please let me know.
>>>
>>> For Fedora folks, I'm currently rebuilding the COPR
>>> pcmoore/kernel-secnext kernel packages with this update; assuming
>>> there are no problems with the COPR infrastructure the kernel should
>>> be ready in a couple of hours.
>>>
>>> * https://copr.fedorainfracloud.org/coprs/pcmoore/kernel-secnext
>>>
>> Cool once there is a kernel with ovlerlay fs/selinux support I will run
>> it on my laptop and attempt
>> the selinux test suite, if everything goes well I will start running
>> docker on overlay with selinux enforcing mode.
> Okay, the build finished and passes the base SELinux/audit regressions
> tests (I didn't test the SELinux/overlayfs integration yet);
> kernel-4.8.0-0.rc1.git1.1.1.secnext.fc26 or greater will have the
> SELinux/overlayfs patches included.  The link above has instructions
> on enabling the COPR repo on your system.
>
Awesome,  I will try this out in Rawhide now.
