Return-Path: <dwalsh@redhat.com>
Reply-To: dwalsh@redhat.com
Subject: Re: [PATCH] overlayfs: Return error if metadata only copy-up can't be
 enabled
References: <20181026134333.GB17321@redhat.com>
 <CAJfpegu+0iX3BcEXAPQVRpcAWOgyROOT9+Ng92rTp_=1gCBgtg@mail.gmail.com>
 <20181026141640.GC17321@redhat.com> <20181026142846.GD17321@redhat.com>
From: Daniel Walsh <dwalsh@redhat.com>
Message-ID: <5967b067-3c1f-8d4d-1d10-d93493f45ea4@redhat.com>
Date: Fri, 26 Oct 2018 11:40:24 -0400
MIME-Version: 1.0
In-Reply-To: <20181026142846.GD17321@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
To: Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

On 10/26/18 10:28 AM, Vivek Goyal wrote:
> On Fri, Oct 26, 2018 at 10:16:40AM -0400, Vivek Goyal wrote:
>> On Fri, Oct 26, 2018 at 04:10:27PM +0200, Miklos Szeredi wrote:
>>> On Fri, Oct 26, 2018 at 3:43 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>>>> Assume a user wanted to enable metadata only copy-up and passes metacopy=on.
>>>> If this feature can't be enabled, we disable metacopy=off and just leave
>>>> a warning in logs. metacopy=on requires redirect_dir=on (for upper dir)
>>>> or redirect_dir=follow (for non-upper mount).
>>> What's the reason we can't enable these for metacopy=on automatically?
>>>
>>> I mean, the simplest and least surprising behavior would be if
>>> metacopy would simply imply redirect_dir, no?
>> redirect_dir=on is a significant change. And it might be better if
>> users passes it in (instead of enabling it automatically).
>>
>> For example, when redirect_dir is enabled, container runtime software
>> (docker, podman), their logic to generate image does not work and
>> they have to fall back to *slower* method of diff.
>>
>> https://github.com/moby/moby/pull/34342
> Having said that, metacopy=on will have same issue and user need to
> fall back to slower naivediff interface for image generation.
>
> So enabling redirect_dir automatically probably is good. We could
> just drop a message in logs that it has been enabled automatically.
>
> IOW, I can go either way depending on how others feel about it.
>
> Thanks
> Vivek

I think turning them both on and DOCUMENTING the behavior would be good.
