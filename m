MIME-Version: 1.0
In-Reply-To: <CAOQ4uxgg+ntFoFh9zaPP2Xi-0dw-UfCvNawgAptFEN0gVCzQ-Q@mail.gmail.com>
References: <1522333133-24772-1-git-send-email-amir73il@gmail.com>
	<1522333133-24772-4-git-send-email-amir73il@gmail.com>
	<CAJfpegtbvrTTnaoB8k9USp_Ev_PWA64efnaEt+JC_rdYU1sfWg@mail.gmail.com>
	<CAOQ4uxiPB5BB8Wm=qe=HPohDqVMiwFy2niWa5vstgc0Y=nRhyg@mail.gmail.com>
	<CAJfpeguaR0u=JL_ZwAv2cTX3jcwWDPDJ-uk6Fhxua_5BnK8Cww@mail.gmail.com>
	<CAOQ4uxgg+ntFoFh9zaPP2Xi-0dw-UfCvNawgAptFEN0gVCzQ-Q@mail.gmail.com>
Date: Thu, 29 Mar 2018 21:41:40 +0200
Message-ID: <CAJfpegvDW0XvX2dfNqt8_cWGkfU9bNfKkiLzxea+mFWF8Po0XA@mail.gmail.com>
Subject: Re: [PATCH v9 3/7] ovl: constant st_ino for non-samefs with xino
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 29, 2018 at 9:02 PM, Amir Goldstein <amir73il@gmail.com> wrote:

> So you mean same as other features?
>
> OVERLAY_FS_XINO defaults to n
> and mount options xino=on/off.

Yes.

> Makes sense.
> I can do that.

Okay, thanks,

Miklos
