From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [PATCH] utimes: Clamp the timestamps in notify_change()
Date: Mon, 25 Nov 2019 10:16:57 -0800
Message-ID: <CABeXuvo3pToaexO26JarHHkQBWO9355YEyO=NeZh-36KciJu6Q@mail.gmail.com>
References: <20191124193145.22945-1-amir73il@gmail.com>
 <20191125164625.GB28608@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <20191125164625.GB28608@fieldses.org>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: "J . Bruce Fields" <bfields@fieldses.org>
Cc: Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Miklos Szeredi <miklos@szeredi.hu>, y2038 Mailman List <y2038@lists.linaro.org>, Amir Goldstein <amir73il@gmail.com>, Jeff Layton <jlayton@kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

T24gTW9uLCBOb3YgMjUsIDIwMTkgYXQgODo0NiBBTSBKIC4gQnJ1Y2UgRmllbGRzIDxiZmllbGRz
QGZpZWxkc2VzLm9yZz4gd3JvdGU6Cj4KPiBPbiBTdW4sIE5vdiAyNCwgMjAxOSBhdCAwOTozMTo0
NVBNICswMjAwLCBBbWlyIEdvbGRzdGVpbiB3cm90ZToKPiA+IFB1c2ggY2xhbXBpbmcgdGltZXN0
YW1wcyBkb3duIHRoZSBjYWxsIHN0YWNrIGludG8gbm90aWZ5X2NoYW5nZSgpLCBzbwo+ID4gaW4t
a2VybmVsIGNhbGxlcnMgbGlrZSBuZnNkIGFuZCBvdmVybGF5ZnMgd2lsbCBnZXQgc2ltaWxhciB0
aW1lc3RhbXAKPiA+IHNldCBiZWhhdmlvciBhcyB1dGltZXMuCj4KPiBTbywgbmZzZCBoYXMgYWx3
YXlzIGJ5cGFzc2VkIHRpbWVzdGFtcF90cnVuY2F0ZSgpIGFuZCB3ZSd2ZSBuZXZlcgo+IG5vdGlj
ZWQgdGlsbCBub3c/ICBXaGF0IGFyZSB0aGUgc3ltcHRvbXM/ICAoRG8gdGltZXN0YW1wcyBnbyBi
YWNrd2FyZHMKPiBhZnRlciBjYWNoZSBldmljdGlvbiBvbiBmaWxlc3lzdGVtcyB3aXRoIGxhcmdl
IHRpbWUgZ3JhbnVsYXJpdHk/KQo+Cj4gTG9va3MgbGlrZSBnZW5lcmljLzQwMiBoYXMgbmV2ZXIg
cnVuIGluIG15IHRlc3RzOgo+Cj4gICAgICAgICBnZW5lcmljLzQwMiAgICAgW25vdCBydW5dIG5v
IGtlcm5lbCBzdXBwb3J0IGZvciB5MjAzOCBzeXNmcyBzd2l0Y2gKCllvdSBuZWVkIHRoaXMgaW4g
eW91ciB4ZnN0ZXN0OgpodHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3BhdGNoLzExMDQ5NzQ1
LyAuIFRoZSB0ZXN0IGhhcyBiZWVuCnVwZGF0ZWQgcmVjZW50bHkuCgpBbmQsIHlvdSBuZWVkIGEg
Y2hhbmdlIGxpa2UgZm9yIG92ZXJsYXlmcyBhcyBBbWlyIHBvaW50ZWQgb3V0LgoKLURlZXBhCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fClkyMDM4IG1haWxp
bmcgbGlzdApZMjAzOEBsaXN0cy5saW5hcm8ub3JnCmh0dHBzOi8vbGlzdHMubGluYXJvLm9yZy9t
YWlsbWFuL2xpc3RpbmZvL3kyMDM4Cg==
