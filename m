MIME-Version: 1.0
In-Reply-To: <1520547490-25194-1-git-send-email-amir73il@gmail.com>
References: <1520547490-25194-1-git-send-email-amir73il@gmail.com>
Date: Thu, 29 Mar 2018 12:19:17 +0200
Message-ID: <CAJfpegvyjQrJ8MMXHSGx8sDoeMM2P1DvEHZtARp+Vu4bSetzJQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] ovl: opaque xattr should overrule redirect xattr
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 8, 2018 at 11:18 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> opaque xattr and redirect xattr are not expected to be both set on the
> same directory, but in case they do, the opaque directive to stop
> merging lower dirs should overrule an absolute redirect directive to
> escape a pure directory.
>
> This change comes with a cost of removing the optimiaztion for not
> checking opaque xattr on lookup in last parent layer.
> Instead, it adds an optimization for not checking opaque nor redirect
> xattr on lookup in overlay instance lowermost layer.

AFAICS this one's obsoleted by Vivek's "ovl: Set d->last properly
during lookup", so using that one.

Thanks,
Miklos
