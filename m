MIME-Version: 1.0
In-Reply-To: <CAOQ4uxg42nW4V5RdbLq9w2Vk1zUBwGBpxSREgKnm7s46da0RKg@mail.gmail.com>
References: <20181101004813.31349-1-amir73il@gmail.com>
	<20181101004813.31349-2-amir73il@gmail.com>
	<20181101130322.GA15140@redhat.com>
	<CAJfpegsbzNR6hKVrm5+A19D2MqEQat=ytR1TUax-+O2tEb7WFA@mail.gmail.com>
	<CAJfpegsLjG3n7WhzH4YHc-aGDMR-jHOydMmMswn=d6TfPtPRpQ@mail.gmail.com>
	<CAOQ4uxg42nW4V5RdbLq9w2Vk1zUBwGBpxSREgKnm7s46da0RKg@mail.gmail.com>
Date: Thu, 1 Nov 2018 22:39:59 +0100
Message-ID: <CAJfpegsDhAdMCxqL4GBu9PxvDy2=q+syvoyfR8=k-77h=b_Hag@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] ovl: return error on mount if metacopy cannot be enabled
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Nov 1, 2018 at 10:22 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Thu, Nov 1, 2018 at 10:41 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>> On Thu, Nov 1, 2018 at 2:11 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> > On Thu, Nov 1, 2018 at 2:03 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> >> On Thu, Nov 01, 2018 at 02:48:09AM +0200, Amir Goldstein wrote:
>> >
>> >>>
>> >>>               case OPT_METACOPY_ON:
>> >>>                       config->metacopy = true;
>> >>> +                     config->strict = true;
>> >>
>> >> I think either ->strict should go in a separate patch or we should have
>> >> a good description in commit message, explaining why ->strict is there
>> >> and how it will impact behavior going forward.
>> >
>> > I'm redoing Amir's patches a bit, and at the moment I'm more inclined
>> > to leave this after the merge window, since there are so many subtle
>> > details to deal with.
>> >
>> > Back shortly with an updated set.
>>
>> ...this is more complicated than I thought.
>>
>
> My reaction as well when I started to dive in...
> Are you still going to redo the "strict" series?
> With metacopy out of the picture, I can just reorder the patches
> and drop the metacopy=on mentions.
> Let me know if you want me to do that.

I'll post what I have next week (done for this week).

>
>> Anyway, pushed a metacopy fix to overlayfs-next, that I'm pretty happy with.
>>
>
> Me too.
> We should do the same for nfs_export=on implies index=on.
> There are probably more users that just want nfs_export=on
> than users that know what index=on even means.
> Let me know if you want me to do that.

Yeah, probably makes sense.

And there's the annoying fact that nfs_export can't be enabled if
metacopy is on by default...

Not sure how much backward compat headache would involve changing these.

Thanks,
Miklos
