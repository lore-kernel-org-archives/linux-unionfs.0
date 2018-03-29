Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJfpegthMY9PRyMLEiLuu56Y-=tJybDC_4-0MLrSWt1s7Avg1w@mail.gmail.com>
References: <1522333133-24772-1-git-send-email-amir73il@gmail.com>
 <1522333133-24772-4-git-send-email-amir73il@gmail.com> <CAJfpegtbvrTTnaoB8k9USp_Ev_PWA64efnaEt+JC_rdYU1sfWg@mail.gmail.com>
 <CAOQ4uxiPB5BB8Wm=qe=HPohDqVMiwFy2niWa5vstgc0Y=nRhyg@mail.gmail.com>
 <CAJfpeguaR0u=JL_ZwAv2cTX3jcwWDPDJ-uk6Fhxua_5BnK8Cww@mail.gmail.com>
 <CAOQ4uxgg+ntFoFh9zaPP2Xi-0dw-UfCvNawgAptFEN0gVCzQ-Q@mail.gmail.com>
 <CAJfpegvDW0XvX2dfNqt8_cWGkfU9bNfKkiLzxea+mFWF8Po0XA@mail.gmail.com>
 <CAOQ4uxhoMyPD1MQZX4nAzBSag_NrXpZ1ZMOJ8JoW42xVTNW0Yw@mail.gmail.com> <CAJfpegthMY9PRyMLEiLuu56Y-=tJybDC_4-0MLrSWt1s7Avg1w@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 30 Mar 2018 01:10:47 +0300
Message-ID: <CAOQ4uxhvr9UCBNN_RpGPkGai6F9v-g+RD-0H0gw7Ppu2pYS+_A@mail.gmail.com>
Subject: Re: [PATCH v9 3/7] ovl: constant st_ino for non-samefs with xino
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 29, 2018 at 11:04 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Mar 29, 2018 at 9:49 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Thu, Mar 29, 2018 at 10:41 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Thu, Mar 29, 2018 at 9:02 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>
>>>> So you mean same as other features?
>>>>
>>>> OVERLAY_FS_XINO defaults to n
>>>> and mount options xino=on/off.
>>>
>>> Yes.
>>>
>>
>> Wait a minute, but if OVERLAY_FS_XINO=y it doesn't mean
>> that all overlay mounts enforce xino, does it?
>
> Right.
>
>> I think it should be something like
>> OVERLAY_FS_XINO_AUTO to determine only if the auto enabling
>> of xino (i.e. for 32bit file handle encoding) is enabled.
>

Pushed with this change to ovl-xino-v10

Thanks,
Amir.
