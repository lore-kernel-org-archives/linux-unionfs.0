From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 06/10] ovl: force read-only mount with no index dir
Date: Fri, 14 Jul 2017 09:11:43 +0300
Message-ID: <CAOQ4uxiyaQUE1YWicnJ2wcD8DHm-jEdSAzjbQggpGs3OR=aUDQ@mail.gmail.com>
References: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
 <1499777923-29410-7-git-send-email-amir73il@gmail.com> <CAJfpegsz3ZzMQNBY8sDtAoAxGmUQ_ai2f32hMTdXEZ4URzvj7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:36575 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750917AbdGNGLp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 14 Jul 2017 02:11:45 -0400
Received: by mail-yb0-f193.google.com with SMTP id o20so4120963yba.3
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Jul 2017 23:11:44 -0700 (PDT)
In-Reply-To: <CAJfpegsz3ZzMQNBY8sDtAoAxGmUQ_ai2f32hMTdXEZ4URzvj7w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Jul 13, 2017 at 11:11 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, Jul 11, 2017 at 2:58 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> When workdir creation fails, overlay is mounted read-only and
>> remount,rw is not allowed. When index dir creation fails, overlay
>> is mounted readonly, but we also need to enforce no remount,rw in
>> that case.
>
> I don't understand the logic for ovl_show_options().  It should show
> the options supplied, right?  It doesn't currently do that for
> "index=FOO" but this patch doesn't help that, afaics.
>

I'll explain my reasoning for changing the logic of ovl_show_options(),
but in the end, I'm perfectly fine with leaving that function untouched
or with removing the != def_ condition altogether.

for the purpose of the test in ovl_force_readonly(), I wanted to preserve
the admin (or distro) choice for index configuration, so that the following
sequence will fail to remount rw in case index dir creation fails:

mount -t overlay d /m -oro,upperdir=/u,lowerdir=/l,workdlir=/w,index=on
mount /m -oremount,rw

So I removed the "/* Show index=off/on.." hunk which lost the index config.
This is different from the case of !ovl_can_decode_fh() which sets
config.index = false and warns "falling back to index=off.", because there
is no way for admin to ever fix  !ovl_can_decode_fh() failure.
In this case (failure to create indexdir), we preserve the config and warn
"failed ... mounting read-only; ... mount with '-o index=off' to disable.."
to let the admin maybe fix the reason for the failure later while letting
users read the data in the mean while without breaking hardlinks.

So far, I guess you agree with the change?

Then it left ovl_show_options() showing "ro,index=on" which is weird,
because indexing is not on, but showing "ro,index=off" (because of !indexdir)
would have been weird as well, because it leaves no apparent explanation
for the failure to remount rw.
So I opted for "on ro mount, the value of index is not interesting" to
reconcile this dilemma.

Really, I have no strong opinion on the matter, so feel free to change
ovl_show_options() in any way you like. I'll shout if I find your choice
confusing for any configuration.

Thanks,
Amir.
