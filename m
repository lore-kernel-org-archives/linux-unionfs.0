MIME-Version: 1.0
In-Reply-To: <20181026134333.GB17321@redhat.com>
References: <20181026134333.GB17321@redhat.com>
Date: Fri, 26 Oct 2018 16:10:27 +0200
Message-ID: <CAJfpegu+0iX3BcEXAPQVRpcAWOgyROOT9+Ng92rTp_=1gCBgtg@mail.gmail.com>
Subject: Re: [PATCH] overlayfs: Return error if metadata only copy-up can't be enabled
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>, Daniel J Walsh <dwalsh@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Oct 26, 2018 at 3:43 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Assume a user wanted to enable metadata only copy-up and passes metacopy=on.
> If this feature can't be enabled, we disable metacopy=off and just leave
> a warning in logs. metacopy=on requires redirect_dir=on (for upper dir)
> or redirect_dir=follow (for non-upper mount).

What's the reason we can't enable these for metacopy=on automatically?

I mean, the simplest and least surprising behavior would be if
metacopy would simply imply redirect_dir, no?

Thanks,
Miklos
