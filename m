From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2] overlayfs: caller_credentials option bypass creator_cred
Date: Tue, 19 Jun 2018 08:39:08 +0300
Message-ID: <CAOQ4uxjepYO+UqED2is-Qcxs=nYypOtY6LhvRxrJeKiLxduU0g@mail.gmail.com>
References: <20180618192726.67981-1-salyzyn@android.com> <87in6fagxw.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87in6fagxw.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Mark Salyzyn <salyzyn@android.com>, linux-kernel <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-doc@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, Jun 19, 2018 at 1:05 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Mark Salyzyn <salyzyn@android.com> writes:
>
>> All accesses to the lower filesystems reference the creator (mount)
>> context.  This is a security issue as the user context does not
>> overlay the creator context.
>
> Sigh.  You gave Vivek a reasonable description of what is going on
> and then you did not repeat it here.  Your patch description
> very much needs to be fixed.
>
> As I read your patch there you are removing an override in credentials.
> Presumably that override is needed for the fileystem to function.
>
> If that override is needed to function your patch is incorrect
> because it breaks things for no reason.
>
> If that override is not needed it should be safe to explain why
> and simply remove it from overlayfs.
>

Eric is correct about override being needed for filesystem to function
because overlayfs calls mknod and sets trusted xattr.

Alas, overlayfs makes an assumption that if mounter has credentials
to mount, it also has credentials for those other things, which so far,
nobody complained about AFAIK.

There was one complain though about abusing SYS_CAP_RESOURCE
of mounter to exceed underlying ext4 quotas, so that capability has been
recently revoked unconditionally from the override creds - that makes a user
with SYS_CAP_RESOURCE also incapable of exceeding underlying ext4
quotas (a good thing IMO, but that is arguable).

Ideally, the correct solution would be to "merge" the mounter creds and
caller creds and use different combinations of the two in different cases,
but that would complicate the code and the test matrix considerably.

> I don't see any real explanations in this change description.
> So this appears to be an incompletely thought out change.
>
>
> Mostly this looks like someone tried to use the principle of least
> privilege in your Android implementation and got it wrong.  Having given
> the mounter of overlayfs too few privileges this appears to be an
> attempt to get overlayfs to pay the cost of an implementation mistake in
> the Android security model.
>
> That seems like a very unreasonable thing to do.
>

To the best of my knowledge, the Android sepolicy rules for init have been
like that for a very long time. I am not sure why Eric claims the unreasonable
claim. Not sure who the users of overlayfs are going to be though and if
it is possible to guaranty that they have capabilities to mknod and set trusted
xattr (needed for removing dirs among other things).

As it is, the patch is simple enough and only makes an existing functionality
optional, so if it *really* solves the Android use case, and there is
*really* no
other "reasonable" way to configure Android sepolicy, I rather have this patch
than the more "correct" implementation.

Two comments about the patch in case we are going forward with it:

1. I would use the same convention for Kconfig/module param/mount option
as used for other overlayfs defaults, i.e. override_creds=on/off and Kconfig
default which defaults to the legacy behavior.

2. with override_creds=off, all the checks being done during mount become
irrelevant (e.g. mounter can set trusted xattr), so either skip them and issue
a warning saying that we really hope mounter knows what it is doing, or
I don't know what.

Thanks,
Amir.
