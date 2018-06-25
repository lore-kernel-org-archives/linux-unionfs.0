From: Mark Salyzyn <salyzyn@android.com>
Subject: Re: [PATCH v4] overlayfs: override_creds=off option bypass
 creator_cred
Date: Mon, 25 Jun 2018 09:07:02 -0700
Message-ID: <058082af-c3cd-9d0a-8d5c-1999703342d0@android.com>
References: <20180622171605.52989-1-salyzyn@android.com>
 <CAOQ4uxiUaJHZ5coUNwH1ZYQjVB8dmAo0Y0bDKOmZM81tzCqC8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxiUaJHZ5coUNwH1ZYQjVB8dmAo0Y0bDKOmZM81tzCqC8g@mail.gmail.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Randy Dunlap <rdunlap@infradead.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-doc@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On 06/22/2018 11:46 PM, Amir Goldstein wrote:
> Mark,
>
> Thanks for the properly documented patch, but this documentation it
> missing the caveats of this config option and there are severe caveats
> as was discussed on earlier version of the patch.
>
> You should mention the not so minor detail that this option can result
> in inability to delete files/directories from overlay and there me be other
> side effects. This is one of those features that should be warning
> unconditionally that user should really know what user is doing
Agreed, I would like to prevent it becoming a treatise ...

The upperdir tree should match the privileges of the lower tree, and in 
Android that is enforced by a hard-coded built-in map (fs_config for 
DAC, restorecon map for MAC) for the caller writers that never causes 
unexpected adjustments (famous last wurds). The active 
(writers/creators) callers have _more_ privileges than init 
(creator/mounter), and are only available on development (userdebug) 
builds. All else are passive (readers), and although less privileged 
than init, have demonstrable read MAC privs where init does not.
> You did not address my concern that the test for setting trusted xattr
> on mount (ovl_make_workdir) should emit a different kind of warning
> when override_creds=off. In fact, I think it should emit a warning
> when override_creds=off unconditionally to indicate that weird things
> can be expected and we "really hope you know what you are doing".
>
> A new security concern I just noticed - overlayfs calls some vfs
> functions directly to perform operations that are typically not
> allowed to unprivileged users without checking credentials.
> In those cases your patch introduces a security vulnerability.
>
> Examples:
> - overlayfs calls exportfs_decode_fh() on underlying
> fs without checking CAP_DAC_READ_SEARCH
> - overlayfs calls vfs_whiteout() which calls underlying fs mknod
> without checking CAP_MKNOD
>
> Those examples could be easily fixed and you may righfully
> claim that they are bugs, but the fact is that those "bugs" are
> harmless until someone creates an irregular security model
> without capabilities to mount, without capability to mknod.
>
> What's worse is that you have to audit the overlayfs code and
> find all these potential bugs and fix them before changing the
> assumptions that were made over the years about mounter
> credentials.
Thanks, _this_ is what a good review is all about. I will need a deeper 
dive (b/c I did not see these) into all the 'command paths' to determine 
any missed/assumed checks. In Android, all the 'caller' issues I have 
with the existing checks are passive (read), and I would _hate_ to be 
providing them (unchecked and assumed) DAC privileges. In Android, it is 
simpler, they would not pass the first barriers, to the internal assumed 
points in any case, but multilevel security _requires_ us to recheck. 
The active (create/write) callers are few and trusted, but _should_ be 
checked w/o assumption (eg: if 'adb push' is not granted CAP_MKNOD, it 
should be blocked).
> Thanks,
> Amir.

Sincerely -- Mark Salyzyn
