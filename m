From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: fix regression caused by exclusive upper/work dir protection
Date: Fri, 29 Sep 2017 11:31:05 +0300
Message-ID: <CAOQ4uxj6k3wgke8YHwLoQXZNHkuD1YkAMW73VmEuizoNP-TGVA@mail.gmail.com>
References: <1506673327-5906-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1506673327-5906-1-git-send-email-amir73il@gmail.com>
Sender: stable-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>, Euan Kemp <euank@euank.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, "# v4 . 13" <stable@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Sep 29, 2017 at 11:22 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> Enforcing exclusive ownership on upper/work dirs caused a docker
> regression: https://github.com/moby/moby/issues/34672.
>
> Euan spotted the regression and pointed to the offending commit.
> Vivek has brought the regression to my attention and provided this
> reproducer:
>
> Terminal 1:
>
>   mount -t overlay -o workdir=work,lowerdir=lower,upperdir=upper none
>         merged/
>
> Terminal 2:
>
>   unshare -m
>
> Terminal 1:
>
>   umount merged
>   mount -t overlay -o workdir=work,lowerdir=lower,upperdir=upper none
>         merged/
>   mount: /root/overlay-testing/merged: none already mounted or mount point
>          busy
>
> To fix the regression, I replaced the error with an alarming warning.
> With index feature enabled, mount does fail, but logs a suggestion to
> override exclusive dir protection by disabling index.
> Note that index=off mount does take the inuse locks, so a concurrent
> index=off will issue the warning and a concurrent index=on mount will fail.
>
> Documentation was updated to reflect this change.
>
> Fixes: 2cac0c00a6cd ("ovl: get exclusive ownership on upper/work dirs")
> Cc: <stable@vger.kernel.org> # v4.13
> Reported-by: Euan Kemp <euank@euank.com>
> Reported-by: Vivek Goyal <vgoyal@redhat.com>

Euan, Vivek

Apparently, git send-email doesn't pick up the Reported-by tags, so
did not CC you.
Care to test this patch?

I am going to update xfstest overlay/036 to reflect this change:
https://github.com/amir73il/xfstests/commit/c8098b949a0f3338e6f45e94e28ee6b7baa284e7

Vivek,

Do you mind making your reproducer into an xfstest?
If you do, please note that there is currently no _require_namespace
in xfstests and the only test that does use unshare (overlay/020) just fails
when kernel has no namespaces support, so this will have to be fixed.

Thanks!
Amir.
